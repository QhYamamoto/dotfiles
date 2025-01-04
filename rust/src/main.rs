use core::panic;
use std::{collections::HashMap, fs, process::Command};

use my_cli_tool::modules::filesystem::{self, get_wsl_home};

const DIRECTORIES_TO_CREATE: [&str; 2] = ["/.config", "/.config/broot"];
const DOTFILES_DIR: &str = "dotfiles";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let wsl_home = get_wsl_home().expect("Error: Wsl home is Empty!!");
    create_symlinks(&wsl_home)?;
    create_wezterm_symlink_from_windows_to_wsl(&wsl_home)?;
    install_packages(&wsl_home)?;
    create_command_shortcuts(&wsl_home)?;

    Ok(())
}

fn create_symlinks(wsl_home: &String) -> Result<(), Box<dyn std::error::Error>> {
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

    Ok(())
}

fn create_wezterm_symlink_from_windows_to_wsl(
    wsl_home: &String,
) -> Result<(), Box<dyn std::error::Error>> {
    if let Some(win_home) = filesystem::get_win_home() {
        let wsl_home_in_windows_fs_format = filesystem::get_wsl_home_in_windows_fs_format()
            .expect("Error: Failed to get wsl home directory in windows file system format.");

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

fn install_packages(wsl_home: &String) -> Result<(), Box<dyn std::error::Error>> {
    // Install packages via apt and brew.
    for t in ["apt", "brew"] {
        let status = Command::new(format!(
            "{}/{}/sh/installers/{}/install.sh",
            wsl_home, DOTFILES_DIR, t
        ))
        .status()
        .unwrap_or_else(|e| panic!("Failed to install packages via {}: {}", t, e));

        if status.success() {
            println!("All packages installed successfully via {}.", t);
        } else {
            eprintln!("Failed to install some packages via {}.", t);
        }
    }

    // Install packages via shell scripts.
    let script_dir = format!("{}/{}/sh/installers/others", wsl_home, DOTFILES_DIR);
    let scripts = fs::read_dir(&script_dir)
        .map_err(|e| format!("Failed to read directory {}: {}", script_dir, e))?;

    for script_entry in scripts {
        let script_entry = script_entry?;
        let script_path = script_entry.path();

        if script_path.is_dir() {
            continue;
        }

        let status = Command::new("sh")
            .arg(&script_path)
            .status()
            .map_err(|e| format!("Failed to execute script {}: {}", script_path.display(), e))?;

        if !status.success() {
            eprintln!(
                "Script {} failed with status: {}",
                script_path.display(),
                status
            );
        }
    }

    Ok(())
}

fn create_command_shortcuts(wsl_home: &String) -> Result<(), Box<dyn std::error::Error>> {
    let local_bin_dir = format!("{}/.local/bin", wsl_home);
    filesystem::create_dir_if_not_exists(&local_bin_dir)?;

    // Make command shortcuts.
    let command_shortcuts = HashMap::from([("batcat", "bat"), ("fdfind", "fd")]);

    for (original_command, shortcut_command) in command_shortcuts {
        let witch_command = Command::new("which")
            .arg(original_command)
            .output()
            .unwrap_or_else(|e| panic!("Failed to find command {}: {}", original_command, e));

        let status = Command::new("ln")
            .args([
                "-s",
                String::from_utf8_lossy(&witch_command.stdout).trim(),
                &format!("{}/{}", local_bin_dir, shortcut_command),
            ])
            .status()?;

        if status.success() {
            println!("Shortcut for {} created successfully.", original_command);
        } else {
            eprintln!("Failed to create shortcut for {}.", original_command);
        }
    }

    Ok(())
}
