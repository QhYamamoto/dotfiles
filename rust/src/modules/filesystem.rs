use std::{env, fs, io, path::Path, process::Command};

use symlink::{remove_symlink_auto, symlink_auto};

/// Copies a single file from the source to the destination.
///
/// * `src`: Path of the source file.
/// * `dest`: Path of the destination (file or directory).
///
/// If `dest` is a directory, the source file is copied into the directory
/// with the same name as the source file. If `dest` is a file, it is
/// overwritten by the source file.
pub fn copy_file(src: &Path, dest: &Path) -> io::Result<()> {
    if !src.is_file() {
        return Err(io::Error::new(
            io::ErrorKind::InvalidInput,
            "Source is not a file",
        ));
    }

    if !dest.is_dir() {
        fs::copy(src, dest).map_err(|e| {
            io::Error::new(
                e.kind(),
                format!("Failed to copy file to {:?}: {}", dest, e),
            )
        })?;
        return Ok(());
    }

    let dest_file =
        dest.join(src.file_name().ok_or_else(|| {
            io::Error::new(io::ErrorKind::InvalidInput, "Invalid source file name")
        })?);
    fs::copy(src, dest_file.clone()).map_err(|e| {
        io::Error::new(
            e.kind(),
            format!("Failed to copy file to {:?}: {}", dest_file, e),
        )
    })?;

    Ok(())
}

/// Copies all contents of a directory to the destination directory.
///
/// * `src`: Path of the source directory.
/// * `dest`: Path of the destination directory.
///
/// If the destination directory does not exist, it is created. The function
/// recursively copies all files and subdirectories from the source to the
/// destination.
pub fn copy_dir(src: &Path, dest: &Path) -> io::Result<()> {
    if !src.is_dir() {
        return Err(io::Error::new(
            io::ErrorKind::InvalidInput,
            "Source is not a directory",
        ));
    }

    if dest.exists() && !dest.is_dir() {
        return Err(io::Error::new(
            io::ErrorKind::InvalidInput,
            "Destination is not a directory",
        ));
    }

    if !dest.exists() {
        fs::create_dir_all(dest)?;
    }

    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let src_path = entry.path();
        let dest_path = dest.join(entry.file_name());

        if src_path.is_dir() {
            copy_item(&src_path, &dest_path)?;
        } else {
            fs::copy(&src_path, &dest_path).map_err(|e| {
                io::Error::new(
                    e.kind(),
                    format!(
                        "Failed to copy file {:?} to {:?}: {}",
                        src_path, dest_path, e
                    ),
                )
            })?;
        }
    }

    Ok(())
}

/// Copies a file or directory from the source to the destination.
///
/// * `src`: Path of the source item (file or directory).
/// * `dest`: Path of the destination item.
///
/// If the source is a file, it is copied using `copy_file`. If the source
/// is a directory, it is copied using `copy_dir`. The function validates
/// that the source exists before attempting the copy.
pub fn copy_item(src: &Path, dest: &Path) -> io::Result<()> {
    if !src.exists() {
        return Err(io::Error::new(
            io::ErrorKind::NotFound,
            "Source path not found",
        ));
    }

    if src.is_file() {
        copy_file(src, dest)
    } else if src.is_dir() {
        copy_dir(src, dest)
    } else {
        Err(io::Error::new(
            io::ErrorKind::InvalidInput,
            "Source is neither a file nor a directory",
        ))
    }
}

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

pub fn get_win_home_in_wsl_fs_format() -> Option<String> {
    if let Some(win_home) = get_win_home() {
        let win_home_in_wsl_format = String::from_utf8_lossy(
            &Command::new("wslpath")
                .args([&win_home])
                .output()
                .ok()?
                .stdout,
        )
        .trim()
        .to_string();

        if win_home_in_wsl_format.is_empty() {
            return None;
        }

        return Some(win_home_in_wsl_format);
    }

    None
}

/// Get wsl home directory name.
pub fn get_wsl_home() -> Option<String> {
    let wsl_home = env::var("HOME").expect("Error: Environment Variable `HOME` is not set.");

    if wsl_home.is_empty() {
        return None;
    }

    Some(wsl_home)
}

/// Get wsl home directory name in Windows filesystem format.
pub fn get_wsl_home_in_windows_fs_format() -> Option<String> {
    if let Some(wsl_home) = get_wsl_home() {
        let wsl_home_in_windows_fs_format = String::from_utf8_lossy(
            &Command::new("wslpath")
                .args(["-w", &wsl_home])
                .output()
                .ok()?
                .stdout,
        )
        .trim()
        .to_string();

        if wsl_home_in_windows_fs_format.is_empty() {
            return None;
        }

        return Some(wsl_home_in_windows_fs_format);
    }

    None
}
