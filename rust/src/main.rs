use clap::{Arg, Command};
use clap_complete::{generate, Shell};
use dotfiles::modules::filesystem::get_wsl_home;
use std::io;
use std::process::Command as ProcessCommand;

mod commands;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut app = Command::new("dotfiles")
        .about("Custom dotfiles command.")
        .subcommand(Command::new("init").about("Initialize dotfiles settings."))
        .subcommand(Command::new("ahk").about("Install ahk and reset its settings."))
        .subcommand(
            Command::new("git")
                .about("Add ssh setting for git service.")
                .arg(
                    Arg::new("overwrite")
                        .long("overwrite-global-config")
                        .help("Overwrite global Git configuration (user.name and user.email)")
                        .action(clap::ArgAction::SetTrue),
                )
                .arg(
                    Arg::new("host")
                        .short('H')
                        .long("host")
                        .required(false)
                        .value_name("HOST")
                        .help("The Git host")
                        .num_args(1),
                )
                .arg(
                    Arg::new("user")
                        .short('u')
                        .long("user")
                        .required(false)
                        .value_name("USER")
                        .help("The Git username")
                        .num_args(1),
                )
                .arg(
                    Arg::new("email")
                        .short('e')
                        .long("email")
                        .required(false)
                        .value_name("EMAIL")
                        .help("The Git user email")
                        .num_args(1),
                )
                .arg(
                    Arg::new("key")
                        .short('k')
                        .long("key")
                        .required(false)
                        .value_name("KEY")
                        .help("The SSH key pair name")
                        .num_args(1),
                ),
        )
        .subcommand(
            Command::new("config")
                .about("Open config directory of a specific tool in neovim.")
                .arg(
                    Arg::new("tool")
                        .required(true)
                        .value_parser(clap::builder::PossibleValuesParser::new([
                            "broot",
                            "lazydocker",
                            "lazygit",
                            "nvim",
                            "wezterm",
                        ]))
                        .help("The app name to configure")
                        .num_args(1),
                ),
        )
        .subcommand(
            Command::new("sync")
                .about("Synchronize dotfiles command.")
                .arg(
                    Arg::new("shell")
                        .required(false)
                        .default_value("zsh")
                        .value_parser(clap::value_parser!(Shell))
                        .help("The shell to generate the compdef script for"),
                ),
        )
        .subcommand(
            Command::new("completion")
                .about("Generate shell completion scripts.")
                .arg(
                    Arg::new("shell")
                        .required(true)
                        .value_parser(clap::value_parser!(Shell))
                        .help("The shell to generate the script for"),
                ),
        );

    let matches = app.clone().get_matches();

    match matches.subcommand() {
        Some(("init", _)) => {
            commands::init::run()?;
        }
        Some(("ahk", _)) => {
            commands::ahk::run()?;
        }
        Some(("git", sub_matches)) => {
            commands::git::run(sub_matches)?;
        }
        Some(("config", sub_matches)) => {
            commands::config::run(sub_matches)?;
        }
        Some(("sync", sub_matches)) => {
            let shell = sub_matches
                .get_one::<Shell>("shell")
                .expect("Shell type is required");
            commands::sync::run(*shell, &mut app)?;
        }
        Some(("completion", sub_matches)) => {
            let shell = sub_matches
                .get_one::<Shell>("shell")
                .expect("Shell type is required");
            generate(*shell, &mut app, "dotfiles", &mut io::stdout());
        }
        _ => {
            ProcessCommand::new("sh")
                .arg("-c")
                .arg(format!("cd {}/dotfiles && nvim", get_wsl_home().unwrap()))
                .spawn()?
                .wait()?;
        }
    }

    Ok(())
}
