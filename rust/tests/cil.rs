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

#[test]
fn test_with_temporary_sudo_privileges_success() {
    let result = cli::with_temporary_sudo_privileges(|| {
        cli::run_command(
            &["sudo", "echo", "Testing sudo privileges"],
            "Failed to echo with sudo",
        )?;
        Ok(())
    });

    assert!(
        result.is_ok(),
        "Expected success when running simple command with temporary sudo privileges"
    );
}

#[test]
fn test_with_temporary_sudo_privileges_failure() {
    let result = cli::with_temporary_sudo_privileges(|| {
        cli::run_command(
            &["nonexistent_command"],
            "Failed to run nonexistent command",
        )?;
        Ok(())
    });

    assert!(
        result.is_err(),
        "Expected failure when running a non-existent command with temporary sudo privileges"
    );
}
