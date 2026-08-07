return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-project.nvim",
    "ThePrimeagen/harpoon",
  },
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").telescope
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    local auto_session = require "auto-session"

    local project_actions_ok, project_actions = pcall(require, "telescope._extensions.project.actions")

    local function change_project_directory(project_path)
      vim.api.nvim_set_current_dir(project_path)
    end

    local function open_projects()
      local loaded, load_err = pcall(telescope.load_extension, "project")
      if not loaded then
        vim.notify(("telescope-project.nvim failed to load: %s"):format(load_err), vim.log.levels.WARN)
        return
      end

      telescope.extensions.project.project {}
    end

    -- パスをファイル名とcwd相対の親ディレクトリに分解する。fast event内でも安全な
    -- vim.loopと文字列操作のみを使う(vim.fnはfast eventで使えないため避ける)。
    local function split_display_path(opts, path)
      local tail = require("telescope.utils").path_tail(path)
      local cwd = (opts and opts.cwd) or vim.loop.cwd()
      local rel = path
      if cwd and cwd ~= "" and path:sub(1, #cwd) == cwd then
        rel = path:sub(#cwd + 2)
      end
      local parent = rel:match "(.+)/[^/]+$"
      return tail, parent
    end

    -- 「先頭(ファイル名 or ファイル名:行番号) + ディレクトリ」の表示文字列とresults用
    -- ハイライトを組み立てる。ファイル名とディレクトリの境目が分かるよう、ディレクトリ
    -- 部分をComment色(TelescopeResultsComment)にdimする。transform_deviconsは
    -- "アイコン + 空白 + text" を返すので、その分ディレクトリのバイト位置をずらす。
    local function render_path(head, parent, filename)
      local text = parent and (head .. "  " .. parent) or head
      local display, hl_group, icon = require("telescope.utils").transform_devicons(filename, text)
      local highlights = {}
      if hl_group then
        highlights[#highlights + 1] = { { 0, #icon }, hl_group }
      end
      if parent then
        local prefix = icon and (#icon + 1) or 0 -- "アイコン + 空白" のぶん
        local dir_start = prefix + #head + 2 -- headとの区切りは空白2つ
        highlights[#highlights + 1] = { { dir_start, #display }, "TelescopeResultsComment" }
      end
      return display, highlights
    end

    -- find_files / grep のresult表示を差し替えるためのbase entry_maker。
    -- gen_from_file / gen_from_vimgrep は生成時のcwdをパス解決の基準として焼き込むため、
    -- telescope-project等でcwdが変わってもパスが壊れないよう、DirChangedで作り直す。
    local file_base, grep_base
    local function rebuild_bases()
      local make_entry = require "telescope.make_entry"
      file_base = make_entry.gen_from_file { cwd = vim.loop.cwd() }
      grep_base = make_entry.gen_from_vimgrep { cwd = vim.loop.cwd() }
    end
    rebuild_bases()
    vim.api.nvim_create_autocmd("DirChanged", { callback = rebuild_bases })

    -- find_files: ファイル名先頭 + dimしたディレクトリで表示する。
    local function file_entry_maker(line)
      local entry = file_base(line)
      if entry == nil then
        return nil
      end
      entry.display = function(e)
        local tail, parent = split_display_path({ cwd = vim.loop.cwd() }, e.value)
        return render_path(tail, parent, e.value)
      end
      return entry
    end

    -- live_grep / grep_string: 各行末のマッチテキスト(entry.text)を消し、
    -- 「ファイル名:行番号 + dimしたディレクトリ」だけを表示する。表示のみ差し替えで、
    -- 絞り込み用のordinalは元のままなので入力によるマッチテキスト絞り込みは効く。
    local function grep_entry_maker(line)
      local entry = grep_base(line)
      if entry == nil then
        return nil
      end
      entry.display = function(e)
        local tail, parent = split_display_path({ cwd = vim.loop.cwd() }, e.filename)
        local head = e.lnum and string.format("%s:%s", tail, e.lnum) or tail
        return render_path(head, parent, e.filename)
      end
      return entry
    end

    telescope.setup {
      extensions = {
        project = {
          base_dirs = { "~" },
          cd_scope = { "global", "tab", "window" },
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true,
          on_project_selected = function(prompt_bufnr)
            if not project_actions_ok then
              vim.notify("telescope-project actions are unavailable", vim.log.levels.WARN)
              return
            end

            local project_path = project_actions.get_selected_path(prompt_bufnr)
            actions.close(prompt_bufnr)

            local restored = auto_session.autosave_and_restore(project_path)
            if not restored then
              change_project_directory(project_path)
            end

            vim.defer_fn(function()
              pcall(function()
                require("harpoon.ui").nav_file(1)
              end)
            end, 50)
          end,
        },
      },
      defaults = {
        -- ファイル名を先頭に出し、その後ろにcwd相対のディレクトリを添える。同名ファイル
        -- でもファイル名がまず読め、被ったときは後続のディレクトリで区別できる。これは
        -- 専用entry_makerを持たないpicker(buffers/oldfiles/lsp参照等)向けのフォールバック。
        -- このtelescope(0.1.x)はpath_display関数の戻り値ハイライトを反映しないため、
        -- ここではディレクトリのdimは付かない(find_files/grepは専用entry_makerでdim付き)。
        path_display = function(opts, path)
          local tail, parent = split_display_path(opts, path)
          if not parent or parent == "" then
            return tail
          end
          return string.format("%s  %s", tail, parent)
        end,
        -- resultsが広くなりすぎるので、余った横幅はpreview側へ回す。telescopeはresults
        -- 幅を内容に合わせて可変にはできないため、全体幅とpreview比率で釣り合いを取る。
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.65,
          },
        },
        file_ignore_patterns = { ".git/" },
        mappings = plugin_keymaps.insert_mappings(actions),
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--ignore", "--iglob", "!.git", "--hidden", "--files" },
          entry_maker = file_entry_maker,
        },
        grep_string = {
          additional_args = { "--hidden" },
          entry_maker = grep_entry_maker,
        },
        live_grep = {
          additional_args = { "--hidden" },
          entry_maker = grep_entry_maker,
        },
      },
    }

    telescope.load_extension "fzf"

    plugin_keymaps.setup(open_projects)
  end,
}
