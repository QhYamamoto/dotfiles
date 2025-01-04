use std::{
    fs,
    io::{self, Write},
    path::Path,
    process::Command,
};

use my_cli_tool::modules::filesystem;

const DOTFILES_DIR: &str = "dotfiles";

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let wsl_home = filesystem::get_wsl_home().expect("Failed to get WSL home directory.");
    let win_home = filesystem::get_win_home().expect("Failed to get Windows home directory.");

    println!(
        "Setting up AutoHotKey on Windows. Please kill all AutoHotKey processes before continuing."
    );
    print!("Press Enter to continue...");
    io::stdout().flush()?;
    let mut input = String::new();
    io::stdin().read_line(&mut input)?;

    let src_dir = format!("{}/{}/ahk", wsl_home, DOTFILES_DIR);
    println!("{}", src_dir);
    let src = Path::new(&src_dir);
    let dest_dir = format!("{}/.ahk", win_home);
    let dest = Path::new(&dest_dir);

    if dest.exists() {
        fs::remove_dir_all(dest)?;
    }

    copy_dir(src, dest)?;

    let status = Command::new(format!(
        "{}/{}/sh/installers/ahk/install.sh",
        wsl_home, DOTFILES_DIR,
    ))
    .status()
    .unwrap_or_else(|e| panic!("Failed to install ahk: {}", e));

    if status.success() {
        println!("Ahk installed successfully.");
    } else {
        eprintln!("Failed to install ahk.");
    }

    println!("AutoHotKey setup completed successfully.");

    Ok(())
}

/// Copies all items from the source directory to the destination directory.
///
/// * `src`: Path of source directory.
/// * `dest`: Path of destination directory.
fn copy_dir(src: &Path, dest: &Path) -> io::Result<()> {
    if !src.exists() {
        return Err(io::Error::new(
            io::ErrorKind::NotFound,
            "Source directory not found",
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
            copy_dir(&src_path, &dest_path)?;
        } else {
            fs::copy(&src_path, &dest_path)?;
        }
    }

    Ok(())
}
