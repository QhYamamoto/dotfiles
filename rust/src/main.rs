use std::{collections::HashMap, env};

use my_cli_tool::modules::filesystem;

const DIRECTORIES_TO_CREATE: [&str; 2] = ["/.config", "/.config/broot"];
const DOTFILES_DIR: &str = "dotfiles";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let home = env::var("HOME").expect("Error: Environment Variable `HOME` is not set.");

    for dir in DIRECTORIES_TO_CREATE {
        let full_path = home.clone() + dir;
        filesystem::create_dir_if_not_exists(&full_path)?;
    }

    let symlink_hash_map: HashMap<&str, Vec<&str>> = HashMap::from([
        (
            "", // Prefix must start without `/`!!
            vec!["zshrc", "p10k.zsh", "zenhan.zsh"],
        ),
        (
            "config",
            vec![
                "/broot/config.toml",
                "/broot/open_file.sh",
                "/lazygit",
                "/lazydocker",
                "/nvim",
                "/wezterm",
            ],
        ),
    ]);

    for (prefix, sources) in symlink_hash_map {
        for source in sources {
            let dest = format!("{}/.{}{}", home, prefix, source);
            let src = format!("{}/{}/home/{}{}", home, DOTFILES_DIR, prefix, source);

            println!("Try to create symlink: {} -> {}", src, dest);
            filesystem::create_symlink(&src, &dest)?;
        }
    }

    Ok(())
}
