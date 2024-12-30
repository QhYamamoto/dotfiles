use std::{fs, path::Path, process::Command};

use symlink::{remove_symlink_auto, symlink_auto};

/// Create directory if not exists.
///
/// * `dir`: Directory name that is to be created.
pub fn create_dir_if_not_exists(dir: &str) -> Result<(), Box<dyn std::error::Error>> {
    let path = Path::new(dir);
    if path.exists() {
        return Ok(());
    }

    fs::create_dir_all(dir).unwrap_or_else(|_| panic!("Failed to create directory: {}", dir));
    println!("Directory created: {}", dir);

    Ok(())
}

/// Create symbolic link.
///
/// * `src`: Source file/directory path.
/// * `dest`: Destination symlink path.
pub fn create_symlink(src: &str, dest: &str) -> Result<(), Box<dyn std::error::Error>> {
    let src_path = Path::new(src);
    let dest_path = Path::new(dest);

    if dest_path.exists() || dest_path.is_symlink() {
        println!("Remove existing symlink: {}", dest);
        remove_symlink_auto(dest_path)
            .unwrap_or_else(|_| panic!("Failed to remove symlink: {}", dest));
    }

    symlink_auto(src_path, dest_path)
        .unwrap_or_else(|_| panic!("Failed to create symlink: {} -> {}", src, dest));

    println!("Symlink created: {} -> {}", src, dest);

    Ok(())
}

pub fn get_win_home() -> Option<String> {
    let win_home = String::from_utf8_lossy(
        &Command::new("cmd.exe")
            .args(["/C", "echo %HOMEDRIVE%%HOMEPATH%"])
            .output()
            .ok()?
            .stdout,
    )
    .trim()
    .to_string();

    if win_home.is_empty() {
        return None;
    }

    Some(win_home)
}

pub fn get_wsl_home_in_windows_fs_format(wsl_home: &str) -> Option<String> {
    let wsl_home_in_windows_fs_format = String::from_utf8_lossy(
        &Command::new("wslpath")
            .args(["-w", wsl_home])
            .output()
            .ok()?
            .stdout,
    )
    .trim() // 改行や余分な空白を削除
    .to_string();

    if wsl_home_in_windows_fs_format.is_empty() {
        return None;
    }

    Some(wsl_home_in_windows_fs_format)
}
