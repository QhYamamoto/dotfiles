use rand::distributions::Alphanumeric;
use rand::{thread_rng, Rng};
use std::fs::{self, File};
use std::io;
use std::io::Write;
use std::path::{Path, PathBuf};

use dotfiles::modules::filesystem;

fn generate_random_string() -> String {
    thread_rng()
        .sample_iter(&Alphanumeric)
        .take(10)
        .map(char::from)
        .collect()
}
/// Helper function: Create a temporary directory for testing
fn create_temp_dir() -> PathBuf {
    let temp_dir = std::env::temp_dir().join("test_copy_item");
    if temp_dir.exists() {
        fs::remove_dir_all(&temp_dir).unwrap();
    }
    fs::create_dir_all(&temp_dir).unwrap();
    temp_dir
}

/// Test copying a file to a destination
#[test]
fn test_copy_file() {
    let temp_dir = create_temp_dir();

    // Create a source file
    let src_file = temp_dir.join("source.txt");
    let mut file = File::create(&src_file).unwrap();
    writeln!(file, "Hello, world!").unwrap();

    // Specify the destination file
    let dest_file = temp_dir.join("destination.txt");

    // Test copying the file
    filesystem::copy_item(&src_file, &dest_file).unwrap();

    // Verify that the destination file exists and its content matches the source
    assert!(dest_file.exists());
    let dest_content = fs::read_to_string(dest_file).unwrap();
    assert_eq!(dest_content, "Hello, world!\n");
}

/// Test copying a directory and its contents
#[test]
fn test_copy_directory() {
    let temp_dir = create_temp_dir();

    // Create a source directory and a file inside it
    let src_dir = temp_dir.join("source_dir");
    fs::create_dir_all(&src_dir).unwrap();
    let src_file = src_dir.join("file.txt");
    let mut file = File::create(&src_file).unwrap();
    writeln!(file, "Directory content").unwrap();

    // Specify the destination directory
    let dest_dir = temp_dir.join("destination_dir");

    // Test copying the directory
    filesystem::copy_item(&src_dir, &dest_dir).unwrap();

    // Verify that the destination directory and its contents exist
    let dest_file = dest_dir.join("file.txt");
    assert!(dest_file.exists());
    let dest_content = fs::read_to_string(dest_file).unwrap();
    assert_eq!(dest_content, "Directory content\n");
}

/// Test when the source path does not exist
#[test]
fn test_nonexistent_source() {
    let temp_dir = create_temp_dir();

    // Define a nonexistent source path
    let src_path = temp_dir.join("nonexistent.txt");
    let dest_path = temp_dir.join("destination.txt");

    // Verify that an error is returned
    let result = filesystem::copy_item(&src_path, &dest_path);
    assert!(result.is_err());
    assert_eq!(result.unwrap_err().kind(), io::ErrorKind::NotFound);
}

/// Test overwriting an existing destination file
#[test]
fn test_overwrite_file() {
    let temp_dir = create_temp_dir();

    // Create a source file
    let src_file = temp_dir.join("source.txt");
    let mut src = File::create(&src_file).unwrap();
    writeln!(src, "New content").unwrap();

    // Create a destination file with old content
    let dest_file = temp_dir.join("destination.txt");
    let mut dest = File::create(&dest_file).unwrap();
    writeln!(dest, "Old content").unwrap();

    // Test overwriting the destination file
    filesystem::copy_item(&src_file, &dest_file).unwrap();

    // Verify that the destination file is overwritten with the source content
    let dest_content = fs::read_to_string(dest_file).unwrap();
    assert_eq!(dest_content, "New content\n");
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
    if let Some(win_home_in_wsl_format) = filesystem::get_win_home_in_wsl_fs_format() {
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
