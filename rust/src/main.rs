use clap::{Arg, Command};
use clap_complete::{generate, Shell};
use std::io;

mod commands; // サブコマンドのモジュールを読み込む

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut app = Command::new("my-cli-tool")
        .about("An example CLI application with auto-completion")
        .subcommand(Command::new("init").about("Initialize dotfiles settings."))
        .subcommand(Command::new("ahk").about("Install ahk and reset its settings."))
        .subcommand(Command::new("git").about("Add ssh setting for git service."))
        .subcommand(
            Command::new("completion")
                .about("Generate shell completion scripts")
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
        Some(("git", _)) => {
            commands::git::run()?;
        }
        Some(("completion", sub_matches)) => {
            let shell = sub_matches
                .get_one::<Shell>("shell")
                .expect("Shell type is required");
            generate(*shell, &mut app, "my-cli-tool", &mut io::stdout());
        }
        _ => {
            eprintln!("Unknown command. Use --help for usage information.");
        }
    }

    Ok(())
}
