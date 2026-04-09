use dotfiles::modules::filesystem::get_wsl_home;

use crate::commands::init;

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let wsl_home = get_wsl_home().expect("Error: Wsl home is Empty!!");
    init::relink(&wsl_home)?;

    Ok(())
}
