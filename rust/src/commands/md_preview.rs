//! `dtf md-preview <file>` — ローカルの Markdown ツリーを HTTP 配信し、ブラウザで
//! プレビューするサーバ。`.md` へのリクエストはその場で HTML にレンダリングして返すため、
//! `.md` 同士の相互リンク・画像・アンカーがそのまま辿れる。ライブリロードは WSL2 の
//! `/mnt/c` でも確実に効くよう inotify ではなく mtime ポーリングで実装する。
//!
//! サーバの寿命はブラウザのタブに追従する: ライブリロードの SSE 接続を心拍として扱い、
//! 表示中のタブが全て閉じられて一定時間経つとサーバは自動終了する（閉じ忘れ防止）。
//! 稼働中サーバは `--list` で一覧、`--stop-all` で一括停止できる。

use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::io::{self, Read, Write};
use std::net::{SocketAddr, TcpListener, TcpStream};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Mutex, OnceLock};
use std::thread;
use std::time::{Duration, Instant, SystemTime};

use clap::ArgMatches;
use comrak::nodes::{NodeHtmlBlock, NodeValue};
use comrak::plugins::syntect::{SyntectAdapter, SyntectAdapterBuilder};
use comrak::{format_html_with_plugins, parse_document, Arena, Options, Plugins};
use tiny_http::{Header, Request, Response, Server, StatusCode};

type BoxErr = Box<dyn std::error::Error>;

const STYLE_CSS: &str = include_str!("md_preview_assets/style.css");
const MERMAID_CDN: &str = "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js";
/// 表示中のタブ（SSE 接続）が 0 本のまま経過したらサーバを畳むまでの猶予。
/// リンク遷移で SSE が一瞬切れて張り直る隙間より十分長く取る。
const IDLE_GRACE: Duration = Duration::from_secs(90);
/// 1 本の SSE 接続を張りっぱなしにする上限。これを超えるとサーバ側からストリームを終える。
/// ブラウザの EventSource は自動再接続するので生きているタブは接続数を保ち続け、閉じられた
/// タブは再接続してこない。この「定期的な国勢調査」で切断を確実に検知する（`tiny_http` への
/// 書き込みは死んだ相手でもしばらく成功してしまい、書き込み失敗による検知は当てにならないため）。
const SSE_MAX: Duration = Duration::from_secs(45);
const PING_MARKER: &str = "dtf-md-preview";

/// serve ループが共有する状態。稼働中の SSE 接続数と、最後に接続数が動いた時刻を持つ。
struct Ctx {
    root: PathBuf,
    port: u16,
    active: AtomicUsize,
    last_change: Mutex<Instant>,
}

impl Ctx {
    fn touch(&self) {
        if let Ok(mut t) = self.last_change.lock() {
            *t = Instant::now();
        }
    }
}

pub fn run(matches: &ArgMatches) -> Result<(), BoxErr> {
    if matches.get_flag("list") {
        list_servers();
        return Ok(());
    }
    if matches.get_flag("stop-all") {
        stop_all_servers();
        return Ok(());
    }

    let file_arg = matches
        .get_one::<String>("file")
        .ok_or("md-preview: a FILE argument is required (or use --list / --stop-all)")?;
    let file = fs::canonicalize(file_arg)
        .map_err(|e| format!("cannot resolve {}: {}", file_arg, e))?;

    let root = match matches.get_one::<String>("root") {
        Some(r) => {
            fs::canonicalize(r).map_err(|e| format!("cannot resolve root {}: {}", r, e))?
        }
        None => detect_root(&file),
    };

    let relpath = file
        .strip_prefix(&root)
        .map(rel_to_url)
        .unwrap_or_else(|_| {
            file.file_name()
                .map(|n| n.to_string_lossy().into_owned())
                .unwrap_or_default()
        });

    let port = match matches.get_one::<String>("port") {
        Some(p) => p.parse::<u16>().map_err(|_| format!("invalid port: {}", p))?,
        None => port_for_root(&root),
    };

    if matches.get_flag("stop") {
        if stop_server(port) {
            println!("md-preview: stopped server on 127.0.0.1:{}", port);
        } else {
            println!("md-preview: no server was running for {}", root.display());
        }
        return Ok(());
    }

    let url = format!("http://127.0.0.1:{}/{}", port, relpath);

    // --daemon: 実サーバ本体。フォアグラウンド起動から detached で呼ばれ、配信ループに入る。
    if matches.get_flag("daemon") {
        return run_server(root, port);
    }

    // フォアグラウンド（＝制御）起動。素早く結果を1行返して終わり、実サーバはバックグラウンドに残す。
    // これにより nvim 側は終了を待って正確なメッセージ（稼働 URL 等）を出せる。
    if ping(port).is_some() {
        open_browser(&url);
        println!("md-preview: already serving, opened {}", url);
        return Ok(());
    }

    spawn_daemon(file_arg, &root, port)?;
    if wait_until_up(port, Duration::from_secs(3)) {
        open_browser(&url);
        println!("md-preview: serving {} at {}", root.display(), url);
        Ok(())
    } else {
        Err(format!("md-preview: server did not come up at {}", url).into())
    }
}

/// 実サーバ本体（`--daemon`）。ポートを掴めたら配信ループへ入り、掴めなければ静かに終わる。
fn run_server(root: PathBuf, port: u16) -> Result<(), BoxErr> {
    match TcpListener::bind(("127.0.0.1", port)) {
        Ok(listener) => {
            let server = Server::from_listener(listener, None)
                .map_err(|e| format!("failed to start server: {}", e))?;
            write_registry(port, &root);
            serve(server, root, port);
        }
        // 競合で他のデーモンが先に掴んだ → 何もせず終了。
        Err(ref e) if e.kind() == io::ErrorKind::AddrInUse => Ok(()),
        Err(e) => Err(format!("failed to bind 127.0.0.1:{}: {}", port, e).into()),
    }
}

/// 自分自身を `--daemon` として detached 起動する（実サーバをバックグラウンドに残すため）。
fn spawn_daemon(file: &str, root: &Path, port: u16) -> Result<(), BoxErr> {
    let exe = std::env::current_exe()?;
    Command::new(exe)
        .arg("md-preview")
        .arg(file)
        .arg("--daemon")
        .arg("--root")
        .arg(root)
        .arg("--port")
        .arg(port.to_string())
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()?;
    Ok(())
}

fn wait_until_up(port: u16, timeout: Duration) -> bool {
    let start = Instant::now();
    while start.elapsed() < timeout {
        if ping(port).is_some() {
            return true;
        }
        thread::sleep(Duration::from_millis(100));
    }
    false
}

/// serve ループ。リクエストごとにスレッドを起こし、長寿命な SSE 接続が他リクエストを
/// 塞がないようにする。別スレッドで監視を回し、表示タブが全滅して猶予が過ぎたら自動終了する。
fn serve(server: Server, root: PathBuf, port: u16) -> ! {
    let ctx = Arc::new(Ctx {
        root,
        port,
        active: AtomicUsize::new(0),
        last_change: Mutex::new(Instant::now()),
    });

    {
        let ctx = Arc::clone(&ctx);
        thread::spawn(move || monitor(ctx));
    }

    let server = Arc::new(server);
    loop {
        match server.recv() {
            Ok(request) => {
                let ctx = Arc::clone(&ctx);
                thread::spawn(move || {
                    if let Err(e) = handle(request, &ctx) {
                        eprintln!("md-preview: request error: {}", e);
                    }
                });
            }
            Err(e) => {
                eprintln!("md-preview: recv error: {}", e);
                break;
            }
        }
    }
    remove_registry(port);
    std::process::exit(0);
}

/// 表示中のタブ（SSE 接続）が 0 本のまま猶予を超えたらサーバを終了する。猶予は
/// `DTF_MD_PREVIEW_IDLE_SECS` で上書きでき、0 を指定すると自動終了を無効化する。
fn monitor(ctx: Arc<Ctx>) -> ! {
    let grace = idle_grace();
    loop {
        thread::sleep(Duration::from_secs(5));
        if ctx.active.load(Ordering::SeqCst) > 0 {
            ctx.touch();
        } else if let Some(grace) = grace {
            let idle = ctx
                .last_change
                .lock()
                .map(|t| t.elapsed())
                .unwrap_or_default();
            if idle > grace {
                remove_registry(ctx.port);
                std::process::exit(0);
            }
        }
    }
}

fn idle_grace() -> Option<Duration> {
    match std::env::var("DTF_MD_PREVIEW_IDLE_SECS") {
        Ok(v) => match v.trim().parse::<u64>() {
            Ok(0) => None, // 自動終了を無効化
            Ok(n) => Some(Duration::from_secs(n)),
            Err(_) => Some(IDLE_GRACE),
        },
        Err(_) => Some(IDLE_GRACE),
    }
}

/// SSE 1 接続の上限（国勢調査の周期）。`DTF_MD_PREVIEW_SSE_SECS` で調整可（主にテスト用）。
fn sse_max() -> Duration {
    match std::env::var("DTF_MD_PREVIEW_SSE_SECS") {
        Ok(v) => match v.trim().parse::<u64>() {
            Ok(n) if n >= 1 => Duration::from_secs(n),
            _ => SSE_MAX,
        },
        Err(_) => SSE_MAX,
    }
}

fn handle(request: Request, ctx: &Arc<Ctx>) -> Result<(), BoxErr> {
    let raw = request.url().to_string();
    let (path_part, query) = match raw.split_once('?') {
        Some((p, q)) => (p, q),
        None => (raw.as_str(), ""),
    };
    let path = percent_decode(path_part);

    if path == "/__shutdown" {
        let _ = request.respond(Response::from_string("bye"));
        remove_registry(ctx.port);
        std::process::exit(0);
    }
    if path == "/__ping" {
        // --list / --stop-all が「これは自分たちのサーバか」を確認し、権威あるルートを得るための応答。
        let body = format!("{}\n{}", PING_MARKER, ctx.root.display());
        request.respond(Response::from_string(body))?;
        return Ok(());
    }
    if path == "/__reload" {
        return handle_reload(request, ctx, query);
    }

    let rel = path.trim_start_matches('/');
    let target = root_join(&ctx.root, rel);
    let target = match fs::canonicalize(&target) {
        Ok(t) => t,
        Err(_) => return respond_status(request, 404, "not found"),
    };
    // ルート外へのパストラバーサルを拒否。
    if !target.starts_with(&ctx.root) {
        return respond_status(request, 403, "forbidden");
    }

    if target.is_dir() {
        for name in ["README.md", "readme.md", "index.md"] {
            let candidate = target.join(name);
            if candidate.is_file() {
                return respond_markdown(request, &candidate, &ctx.root);
            }
        }
        return respond_status(request, 404, "not found");
    }

    match extension(&target).as_deref() {
        Some("md") | Some("markdown") => respond_markdown(request, &target, &ctx.root),
        _ => respond_static(request, &target),
    }
}

fn respond_markdown(request: Request, file: &Path, root: &Path) -> Result<(), BoxErr> {
    let markdown = fs::read_to_string(file)?;
    let relpath = file.strip_prefix(root).map(rel_to_url).unwrap_or_default();
    let (body, has_mermaid) = render_markdown(&markdown);
    let html = page(&relpath, &body, has_mermaid);
    let resp = Response::from_string(html)
        .with_header(header("Content-Type", "text/html; charset=utf-8"));
    request.respond(resp)?;
    Ok(())
}

fn respond_static(request: Request, file: &Path) -> Result<(), BoxErr> {
    let data = fs::read(file)?;
    let resp = Response::from_data(data).with_header(header("Content-Type", content_type(file)));
    request.respond(resp)?;
    Ok(())
}

fn respond_status(request: Request, code: u16, msg: &str) -> Result<(), BoxErr> {
    let resp = Response::from_string(msg).with_status_code(StatusCode(code));
    request.respond(resp)?;
    Ok(())
}

/// `/__reload?path=<relpath>` に対する SSE 応答。対象ファイルの mtime をポーリングし、
/// 変化したら `reload` イベントを流す。この接続が「タブが開いている」心拍になる。
fn handle_reload(request: Request, ctx: &Arc<Ctx>, query: &str) -> Result<(), BoxErr> {
    let rel = percent_decode(&query_get(query, "path").unwrap_or_default());
    let file = root_join(&ctx.root, rel.trim_start_matches('/'));
    let file = match fs::canonicalize(&file) {
        Ok(f) if f.starts_with(&ctx.root) => f,
        _ => return respond_status(request, 404, "not found"),
    };
    let reader = ReloadReader::new(file, Arc::clone(ctx));
    let headers = vec![
        header("Content-Type", "text/event-stream"),
        header("Cache-Control", "no-cache"),
        header("Connection", "keep-alive"),
    ];
    let resp = Response::new(StatusCode(200), headers, reader, None, None);
    request.respond(resp)?;
    Ok(())
}

/// 表示中の 1 ファイルだけを監視する SSE ボディ。生存中は稼働接続数を +1 し、drop 時に -1 する
/// ことで「タブが開いているか」をサーバへ伝える。
struct ReloadReader {
    file: PathBuf,
    last: Option<SystemTime>,
    buf: Vec<u8>,
    pos: usize,
    ticks: u32,
    started: Instant,
    max: Duration,
    ctx: Arc<Ctx>,
}

impl ReloadReader {
    fn new(file: PathBuf, ctx: Arc<Ctx>) -> Self {
        ctx.active.fetch_add(1, Ordering::SeqCst);
        ctx.touch();
        let last = mtime(&file);
        Self {
            file,
            last,
            buf: Vec::new(),
            pos: 0,
            ticks: 0,
            started: Instant::now(),
            max: sse_max(),
            ctx,
        }
    }
}

impl Drop for ReloadReader {
    fn drop(&mut self) {
        self.ctx.active.fetch_sub(1, Ordering::SeqCst);
        self.ctx.touch();
    }
}

impl Read for ReloadReader {
    fn read(&mut self, out: &mut [u8]) -> io::Result<usize> {
        loop {
            if self.pos < self.buf.len() {
                let n = std::cmp::min(out.len(), self.buf.len() - self.pos);
                out[..n].copy_from_slice(&self.buf[self.pos..self.pos + n]);
                self.pos += n;
                return Ok(n);
            }
            // 上限を超えたらストリームを終える。生きているタブは再接続してくる。
            if self.started.elapsed() >= self.max {
                return Ok(0);
            }
            thread::sleep(Duration::from_millis(300));
            self.ticks += 1;
            let current = mtime(&self.file);
            if current.is_some() && current != self.last {
                self.last = current;
                self.buf = b"data: reload\n\n".to_vec();
                self.pos = 0;
            } else if self.ticks % 10 == 0 {
                // 3 秒ごとのキープアライブ。切断済みならここでの書き込みが失敗し、
                // tiny_http がリーダを drop してスレッドが終了する（＝タブが閉じたと分かる）。
                self.buf = b": keepalive\n\n".to_vec();
                self.pos = 0;
            }
        }
    }
}

fn render_markdown(markdown: &str) -> (String, bool) {
    let mut options = Options::default();
    options.extension.table = true;
    options.extension.strikethrough = true;
    options.extension.tasklist = true;
    options.extension.autolink = true;
    options.extension.footnotes = true;
    options.extension.header_ids = Some(String::new());
    // mermaid ブロックを生 HTML の <div> に差し替えるため raw HTML 出力を許可する。
    options.render.unsafe_ = true;

    let arena = Arena::new();
    let root = parse_document(&arena, markdown, &options);

    let mut has_mermaid = false;
    for node in root.descendants() {
        let source = {
            let data = node.data.borrow();
            match &data.value {
                NodeValue::CodeBlock(cb)
                    if cb.info.split_whitespace().next() == Some("mermaid") =>
                {
                    Some(cb.literal.clone())
                }
                _ => None,
            }
        };
        if let Some(src) = source {
            has_mermaid = true;
            node.data.borrow_mut().value = NodeValue::HtmlBlock(NodeHtmlBlock {
                literal: format!("<div class=\"mermaid\">{}</div>\n", escape_html(&src)),
                block_type: 0,
            });
        }
    }

    let mut plugins = Plugins::default();
    plugins.render.codefence_syntax_highlighter = Some(adapter());

    let mut out = Vec::new();
    format_html_with_plugins(root, &options, &mut out, &plugins)
        .expect("writing to a Vec never fails");
    (String::from_utf8_lossy(&out).into_owned(), has_mermaid)
}

/// syntect のシンタックス／テーマ集合はロードが重いのでプロセス内で一度だけ構築する。
fn adapter() -> &'static SyntectAdapter {
    static ADAPTER: OnceLock<SyntectAdapter> = OnceLock::new();
    ADAPTER.get_or_init(|| {
        SyntectAdapterBuilder::new()
            .theme("base16-ocean.dark")
            .build()
    })
}

fn page(relpath: &str, body: &str, has_mermaid: bool) -> String {
    let mermaid = if has_mermaid {
        format!(
            "<script src=\"{}\"></script>\
             <script>mermaid.initialize({{startOnLoad:true,theme:'dark'}});</script>",
            MERMAID_CDN
        )
    } else {
        String::new()
    };
    let reload = format!(
        "(function(){{try{{var es=new EventSource(\"/__reload?path=\"+encodeURIComponent(\"{}\"));\
         es.onmessage=function(e){{if(e.data===\"reload\"){{location.reload();}}}};}}catch(_){{}}}})();",
        js_escape(relpath)
    );
    format!(
        "<!doctype html><html lang=\"ja\"><head><meta charset=\"utf-8\">\
         <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\
         <title>{title}</title><style>{css}</style></head>\
         <body><article class=\"markdown-body\">{body}</article>\
         {mermaid}<script>{reload}</script></body></html>",
        title = escape_html(relpath),
        css = STYLE_CSS,
        body = body,
        mermaid = mermaid,
        reload = reload,
    )
}

// --- 稼働中サーバの一覧・一括停止 ----------------------------------------

/// 稼働中サーバのレジストリ置き場。プロセスが正常終了すればファイルは消えるが、SIGKILL
/// 等で残っても `--list` / `--stop-all` が `/__ping` で生死確認して掃除する。
fn registry_dir() -> PathBuf {
    let base = std::env::var_os("XDG_RUNTIME_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(std::env::temp_dir);
    base.join("dtf-md-preview")
}

fn write_registry(port: u16, root: &Path) {
    let dir = registry_dir();
    let _ = fs::create_dir_all(&dir);
    let _ = fs::write(
        dir.join(port.to_string()),
        format!("{}\n{}\n", root.display(), std::process::id()),
    );
}

fn remove_registry(port: u16) {
    let _ = fs::remove_file(registry_dir().join(port.to_string()));
}

fn list_servers() {
    let dir = registry_dir();
    let mut ports = registered_ports(&dir);
    ports.sort_unstable();
    let mut running = 0;
    for port in ports {
        match ping(port) {
            Some(root) => {
                println!("  http://127.0.0.1:{}  {}", port, root);
                running += 1;
            }
            None => {
                let _ = fs::remove_file(dir.join(port.to_string()));
            }
        }
    }
    if running == 0 {
        println!("md-preview: no running servers");
    } else {
        println!("md-preview: {} server(s) running", running);
    }
}

fn stop_all_servers() {
    let dir = registry_dir();
    let mut stopped = 0;
    for port in registered_ports(&dir) {
        if stop_server(port) {
            stopped += 1;
        }
        let _ = fs::remove_file(dir.join(port.to_string()));
    }
    println!("md-preview: stopped {} server(s)", stopped);
}

fn registered_ports(dir: &Path) -> Vec<u16> {
    match fs::read_dir(dir) {
        Ok(entries) => entries
            .filter_map(|e| e.ok()?.file_name().to_string_lossy().parse().ok())
            .collect(),
        Err(_) => Vec::new(),
    }
}

/// `/__ping` を叩き、自分たちのサーバなら権威あるルートを返す。落ちていれば None。
fn ping(port: u16) -> Option<String> {
    let addr = SocketAddr::from(([127, 0, 0, 1], port));
    let mut stream = TcpStream::connect_timeout(&addr, Duration::from_millis(200)).ok()?;
    stream
        .set_read_timeout(Some(Duration::from_millis(400)))
        .ok()?;
    stream
        .write_all(b"GET /__ping HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n")
        .ok()?;
    let mut resp = String::new();
    let _ = stream.read_to_string(&mut resp);
    let body = resp.split("\r\n\r\n").nth(1)?;
    let mut lines = body.lines();
    if lines.next()? != PING_MARKER {
        return None;
    }
    Some(lines.next().unwrap_or("").to_string())
}

/// 該当ポートのサーバを停止する。稼働していて停止要求を送れたら true。
fn stop_server(port: u16) -> bool {
    if ping(port).is_none() {
        return false;
    }
    if let Ok(mut stream) = TcpStream::connect(("127.0.0.1", port)) {
        let _ = stream.write_all(
            b"GET /__shutdown HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n",
        );
        let mut buf = [0u8; 64];
        let _ = stream.read(&mut buf);
        return true;
    }
    false
}

// --- ヘルパ ---------------------------------------------------------------

/// `file` の親から上へ `.git` を探し、見つかればそのディレクトリを、無ければ親ディレクトリを
/// 配信ルートとする。相互リンクが `../` を跨いでも解決できるよう git ルートを優先する。
fn detect_root(file: &Path) -> PathBuf {
    let start = file.parent().unwrap_or(file);
    let mut current = Some(start);
    while let Some(dir) = current {
        if dir.join(".git").exists() {
            return dir.to_path_buf();
        }
        current = dir.parent();
    }
    start.to_path_buf()
}

/// 正規化済みルートのハッシュから 6000-6999 のポートを決める。プロジェクトごとに安定した
/// 別ポートになるので複数プロジェクトを同時にプレビューしても衝突しない。
fn port_for_root(root: &Path) -> u16 {
    let mut hasher = DefaultHasher::new();
    root.to_string_lossy().hash(&mut hasher);
    6000 + (hasher.finish() % 1000) as u16
}

/// nvim 側 `open_external` と同じ優先順位でブラウザ（WSL では Windows 側）を開く。
fn open_browser(url: &str) {
    if spawn_detached("wslview", &[url]) {
        return;
    }
    if is_wsl() {
        if spawn_detached("explorer.exe", &[url]) {
            return;
        }
        if spawn_detached(
            "powershell.exe",
            &["-NoProfile", "-Command", "Start-Process $args[0]", url],
        ) {
            return;
        }
    }
    if spawn_detached("xdg-open", &[url]) {
        return;
    }
    eprintln!("md-preview: no browser opener found; open {} manually", url);
}

fn spawn_detached(cmd: &str, args: &[&str]) -> bool {
    Command::new(cmd)
        .args(args)
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .is_ok()
}

fn is_wsl() -> bool {
    if std::env::var_os("WSL_DISTRO_NAME").is_some() {
        return true;
    }
    fs::read_to_string("/proc/sys/kernel/osrelease")
        .map(|s| {
            let s = s.to_lowercase();
            s.contains("microsoft") || s.contains("wsl")
        })
        .unwrap_or(false)
}

fn header(name: &str, value: &str) -> Header {
    Header::from_bytes(name.as_bytes(), value.as_bytes()).expect("valid header")
}

fn root_join(root: &Path, rel: &str) -> PathBuf {
    root.join(rel)
}

fn extension(path: &Path) -> Option<String> {
    path.extension().map(|e| e.to_string_lossy().to_lowercase())
}

fn content_type(path: &Path) -> &'static str {
    match extension(path).as_deref() {
        Some("html") | Some("htm") => "text/html; charset=utf-8",
        Some("css") => "text/css; charset=utf-8",
        Some("js") | Some("mjs") => "text/javascript; charset=utf-8",
        Some("json") => "application/json; charset=utf-8",
        Some("png") => "image/png",
        Some("jpg") | Some("jpeg") => "image/jpeg",
        Some("gif") => "image/gif",
        Some("svg") => "image/svg+xml",
        Some("webp") => "image/webp",
        Some("avif") => "image/avif",
        Some("ico") => "image/x-icon",
        Some("pdf") => "application/pdf",
        // ソースコード等はブラウザで読めるようテキスト扱いにする。
        _ => "text/plain; charset=utf-8",
    }
}

fn mtime(path: &Path) -> Option<SystemTime> {
    fs::metadata(path).and_then(|m| m.modified()).ok()
}

fn rel_to_url(path: &Path) -> String {
    path.to_string_lossy().replace('\\', "/")
}

fn query_get(query: &str, key: &str) -> Option<String> {
    query.split('&').find_map(|pair| {
        let (k, v) = pair.split_once('=')?;
        if k == key {
            Some(v.to_string())
        } else {
            None
        }
    })
}

fn percent_decode(input: &str) -> String {
    let bytes = input.as_bytes();
    let mut out = Vec::with_capacity(bytes.len());
    let mut i = 0;
    while i < bytes.len() {
        if bytes[i] == b'%' && i + 2 < bytes.len() {
            if let (Some(h), Some(l)) = (hex_val(bytes[i + 1]), hex_val(bytes[i + 2])) {
                out.push(h * 16 + l);
                i += 3;
                continue;
            }
        }
        out.push(bytes[i]);
        i += 1;
    }
    String::from_utf8_lossy(&out).into_owned()
}

fn hex_val(b: u8) -> Option<u8> {
    match b {
        b'0'..=b'9' => Some(b - b'0'),
        b'a'..=b'f' => Some(b - b'a' + 10),
        b'A'..=b'F' => Some(b - b'A' + 10),
        _ => None,
    }
}

fn escape_html(input: &str) -> String {
    let mut out = String::with_capacity(input.len());
    for c in input.chars() {
        match c {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            '"' => out.push_str("&quot;"),
            '\'' => out.push_str("&#39;"),
            _ => out.push(c),
        }
    }
    out
}

fn js_escape(input: &str) -> String {
    let mut out = String::with_capacity(input.len());
    for c in input.chars() {
        match c {
            '\\' => out.push_str("\\\\"),
            '"' => out.push_str("\\\""),
            _ => out.push(c),
        }
    }
    out
}
