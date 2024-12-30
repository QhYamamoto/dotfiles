use std::{collections::HashMap, process::Command};

use my_cli_tool::modules::filesystem::{self, get_wsl_home};

const DIRECTORIES_TO_CREATE: [&str; 2] = ["/.config", "/.config/broot"];
const DOTFILES_DIR: &str = "dotfiles";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let wsl_home = get_wsl_home().expect("Wsl home is Empty!!");

    // Make necessary directories.
    for dir in DIRECTORIES_TO_CREATE {
        let full_path = wsl_home.clone() + dir;
        filesystem::create_dir_if_not_exists(&full_path)?;
    }

    // Make symlinks (from linux path to linux path).
    let symlink_hash_map: HashMap<&str, Vec<&str>> = HashMap::from([
        (
            "", // Prefix must start without `/`!!
            vec!["zshrc", "p10k.zsh", "zenhan.zsh"],
        ),
        (
            "config",
            vec![
                "/broot/config.toml",
                "/broot/open_file.sh",
                "/lazygit",
                "/lazydocker",
                "/nvim",
                "/wezterm",
            ],
        ),
    ]);

    for (prefix, sources) in symlink_hash_map {
        for source in sources {
            let dest = format!("{}/.{}{}", wsl_home, prefix, source);
            let src = format!("{}/{}/home/{}{}", wsl_home, DOTFILES_DIR, prefix, source);

            println!("Try to create symlink: {} -> {}", src, dest);
            filesystem::create_symlink(&src, &dest)?;
        }
    }

    // Make symlinks from windows wezterm path to wsl wezterm path.
    if let Some(win_home) = filesystem::get_win_home() {
        let wsl_home_in_windows_fs_format = filesystem::get_wsl_home_in_windows_fs_format()
            .expect("Failed to get wsl home directory in windows file system format.");

        let win_wezterm_dir = format!("{}\\.config\\wezterm", win_home);
        let wsl_wezterm_dir = format!(
            "{}\\{}\\home\\config\\wezterm",
            wsl_home_in_windows_fs_format, DOTFILES_DIR
        );
        let mklink_ps1_path = format!("{}/{}/powershell/mklink.ps1", wsl_home, DOTFILES_DIR);

        Command::new("powershell.exe")
            .args([
                "-ExecutionPolicy",
                "Bypass",
                "-File",
                &mklink_ps1_path,
                "-LinkPath",
                &win_wezterm_dir,
                "-TargetPath",
                &wsl_wezterm_dir,
            ])
            .status()
            .expect("Failed to execute Powershell script.");
    }

    Ok(())
}
