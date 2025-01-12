use clap::ArgMatches;
use dotfiles::modules::filesystem;
use std::process::Command;

pub fn run(matches: &ArgMatches) -> Result<(), Box<dyn std::error::Error>> {
    let tool = matches
        .get_one::<String>("tool")
        .expect("Cannot get tool name");
    Command::new("sh")
        .arg("-c")
        .arg(format!(
            "cd {}/dotfiles/home/config/{} && nvim",
            filesystem::get_wsl_home().unwrap(),
            tool
        ))
        .spawn()?
        .wait()?;

    Ok(())
}
