use dotfiles::modules::cli;
use std::panic;

#[test]
fn test_run_command_success() {
    let result = cli::run_command(&["echo", "hello"], "Failed to run echo");
    assert!(result.is_ok());
}

#[test]
fn test_run_command_failure() {
    let result = panic::catch_unwind(|| {
        let _ = cli::run_command(&["nonexistent_command"], "Failed to run command");
    });

    assert!(
        result.is_err(),
        "Expected panic when running a non-existent command"
    );
}
