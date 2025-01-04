use arboard::Clipboard;
use clap::ArgMatches;
use dotfiles::modules::filesystem;
use std::fs::{self, OpenOptions};
use std::io::{self, Write};
use std::path::Path;
use std::process::Command as ProcessCommand;

pub fn run(matches: &ArgMatches) -> Result<(), Box<dyn std::error::Error>> {
    let overwrite_config = matches.get_flag("overwrite");
    let git_host = matches
        .get_one::<String>("host")
        .map(String::to_owned)
        .unwrap_or_else(|| prompt("Please enter Host: "));
    let git_user_name = matches
        .get_one::<String>("user")
        .map(String::to_owned)
        .unwrap_or_else(|| prompt("Please enter your user name: "));
    let git_user_email = matches
        .get_one::<String>("email")
        .map(String::to_owned)
        .unwrap_or_else(|| prompt("Please enter your email address: "));
    let git_key_pair_name = matches
        .get_one::<String>("key")
        .map(String::to_owned)
        .unwrap_or_else(|| prompt("Please enter ssh key pair name: "));

    // Overwrite global config.
    if overwrite_config {
        run_command(
            &["git", "config", "--global", "user.name", &git_user_name],
            "Failed to set git user name.",
        )?;
        run_command(
            &["git", "config", "--global", "user.email", &git_user_email],
            "Failed to set git email.",
        )?;
    }

    // Create ~/.ssh/config
    let wsl_home = filesystem::get_wsl_home().expect("Failed to get WSL home.");
    let ssh_dir = format!("{}/.ssh", wsl_home);
    let ssh_path = Path::new(&ssh_dir);
    if !ssh_path.exists() {
        fs::create_dir(ssh_path)?;
    }

    // Generate ssh key.
    run_command(
        &[
            "ssh-keygen",
            "-t",
            "ed25519",
            "-C",
            &git_user_email,
            "-f",
            &ssh_path.join(&git_key_pair_name).to_string_lossy(),
        ],
        "Failed to generate SSH keys.",
    )?;

    run_command(
        &[
            "sh",
            "-c",
            &format!(
                "{}/dotfiles/sh/ssh-add.sh \"{}\"",
                wsl_home, git_key_pair_name
            ),
        ],
        "Failed to add private key to ssh-agent.",
    )?;

    // Add lines to ssh config file.
    let ssh_config_path = ssh_path.join("config");
    let mut ssh_config_file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(&ssh_config_path)?;

    writeln!(
        ssh_config_file,
        "Host {}\n  HostName {}\n  User {}\n  IdentityFile {}/{}",
        git_host,
        git_host,
        git_user_name,
        ssh_path.to_string_lossy(),
        git_key_pair_name
    )?;

    // Copy public key to clipboard.
    let pub_key = fs::read_to_string(ssh_path.join(format!("{}.pub", git_key_pair_name)))?;
    let mut clipboard = Clipboard::new()?;
    clipboard.set_text(pub_key)?;

    println!(
        "SSH keys are now set up, and the public key is copied to your clipboard! Please add it to your git service account."
    );

    Ok(())
}

fn prompt(message: &str) -> String {
    print!("{}", message);
    io::stdout().flush().unwrap();
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();

    input.trim().to_string()
}

fn run_command(args: &[&str], error_message: &str) -> Result<(), Box<dyn std::error::Error>> {
    let status = ProcessCommand::new(args[0])
        .args(&args[1..])
        .status()
        .expect(error_message);

    if status.success() {
        Ok(())
    } else {
        Err(format!("{} (command: {:?})", error_message, args).into())
    }
}
