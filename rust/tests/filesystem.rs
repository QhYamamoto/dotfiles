use rand::distributions::Alphanumeric;
use rand::{thread_rng, Rng};
use std::fs;
use std::path::Path;

use dotfiles::modules::filesystem;

fn generate_random_string() -> String {
    thread_rng()
        .sample_iter(&Alphanumeric)
        .take(10)
        .map(char::from)
        .collect()
}

#[test]
fn test_create_dir_if_not_exists() {
    let random_dir_name = format!("/tmp/test_dir_{}", generate_random_string());
    let path = Path::new(&random_dir_name);

    assert!(!path.exists());

    filesystem::create_dir_if_not_exists(&random_dir_name).unwrap();

    assert!(path.exists());
    assert!(path.is_dir());

    fs::remove_dir_all(path).unwrap();
}

#[test]
fn test_create_symlink() {
    let random_str = generate_random_string();

    // testing file type symlink
    let random_file_name = format!("/tmp/test_file_{}", random_str);
    let symlink_file_name = format!("/tmp/symlink_file_{}", random_str);

    fs::write(&random_file_name, "test").unwrap();
    filesystem::create_symlink(&random_file_name, &symlink_file_name).unwrap();
    assert!(Path::new(&symlink_file_name).exists());
    assert!(Path::new(&symlink_file_name).is_symlink());

    fs::remove_file(&symlink_file_name).unwrap();
    fs::remove_file(&random_file_name).unwrap();

    // testing directory type symlink
    let random_dir_name = format!("/tmp/test_dir_{}", random_str);
    let symlink_dir_name = format!("/tmp/symlink_dir_{}", random_str);

    fs::create_dir(&random_dir_name).unwrap();
    filesystem::create_symlink(&random_dir_name, &symlink_dir_name).unwrap();
    assert!(Path::new(&symlink_dir_name).exists());
    assert!(Path::new(&symlink_dir_name).is_symlink());

    fs::remove_file(&symlink_dir_name).unwrap();
    fs::remove_dir_all(&random_dir_name).unwrap();
}

#[test]
fn test_get_win_home() {
    if let Some(win_home) = filesystem::get_win_home() {
        assert!(win_home.starts_with("C:\\Users\\"));
    };
}

#[test]
fn test_get_win_home_in_wsl_format() {
    if let Some(win_home_in_wsl_format) = filesystem::get_win_home_in_wsl_format() {
        assert!(win_home_in_wsl_format.starts_with("/mnt/c/Users"));
    };
}

#[test]
fn test_get_wsl_home() {
    if let Some(wsl_home) = filesystem::get_wsl_home() {
        assert!(wsl_home.starts_with("/home/"));
    };
}

#[test]
fn test_get_wsl_home_in_windows_fs_format() {
    if let Some(wsl_home_in_windows_fs_format) = filesystem::get_wsl_home_in_windows_fs_format() {
        println!("{}", wsl_home_in_windows_fs_format);
        assert!(wsl_home_in_windows_fs_format.starts_with("\\\\wsl"))
    }
}
