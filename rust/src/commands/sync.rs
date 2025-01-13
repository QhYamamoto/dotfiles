use clap::Command;
use clap_complete::{generate_to, Shell};
use dotfiles::constants;
use dotfiles::modules::filesystem;
use std::process::Command as ProcessCommand;

pub fn run(shell: Shell, app: &mut Command) -> Result<(), Box<dyn std::error::Error>> {
    let wsl_home = filesystem::get_wsl_home().unwrap();
    ProcessCommand::new("sh")
        .arg("-c")
        .arg(format!(
            "cd {}/{}/rust && cargo build --release && mv target/release/dotfiles ../{}",
            wsl_home,
            constants::DOTFILES_DIR,
            constants::CUSTOM_COMMAND_BIN_DIR,
        ))
        .spawn()?
        .wait()
        .map_err(|e| format!("Failed to compile: {}", e))?;

    let dest = format!(
        "{}/{}/home/{}/compdef",
        wsl_home,
        constants::DOTFILES_DIR,
        shell
    );
    filesystem::create_dir_if_not_exists(&dest)?;

    generate_to(shell, app, "dotfiles", &dest)
        .map_err(|e| format!("Failed to update compleition file: {}", e))?;

    println!("Sync completed successfully.");

    Ok(())
}
