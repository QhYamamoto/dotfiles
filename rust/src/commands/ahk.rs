use dotfiles::{
    constants::DOTFILES_DIR,
    modules::{cli, filesystem},
};
use std::{
    fs,
    io::{self, Write},
    path::Path,
    process::Command,
};

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let action = || {
        let wsl_home = filesystem::get_wsl_home().expect("Failed to get WSL home directory.");
        let win_home = filesystem::get_win_home_in_wsl_fs_format()
            .expect("Failed to get Windows home directory.");

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

        filesystem::copy_item(src, dest)?;

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
    };

    cli::with_temporary_sudo_privileges(action)?;

    Ok(())
}
