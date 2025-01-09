use std::io::{self, Write};
use std::process::Command;

/// Prompts the user with a message and reads their input from standard input.
///
/// * `message` - A string that will be printed to the standard output as a prompt for the user.
///
/// This function prints the provided message to the standard output and waits for the user
/// to input a line. It then returns the trimmed user input as a `String`.
pub fn prompt(message: &str) -> String {
    print!("{}", message);
    io::stdout().flush().unwrap();
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();

    input.trim().to_string()
}

/// Runs a command with the specified arguments and checks the exit status.
///
/// * `args` - A slice of strings representing the command and its arguments.
/// * `error_message` - An error message that will be included in the error result if the command fails.
///
/// This function takes a command and its arguments, runs the command, and checks whether
/// it succeeded or failed. If the command fails (i.e., the exit status is not success),
/// it returns an error with a provided error message and the command's arguments.
pub fn run_command(args: &[&str], error_message: &str) -> Result<(), Box<dyn std::error::Error>> {
    let status = Command::new(args[0])
        .args(&args[1..])
        .status()
        .expect(error_message);

    if status.success() {
        Ok(())
    } else {
        Err(format!("{} (command: {:?})", error_message, args).into())
    }
}

/// Temporarily grants sudo privileges to the current user, executes the provided action, and then revokes the privileges.
///
/// * `action` - A closure representing the action to be executed with temporary sudo privileges.
///
/// This function temporarily modifies the `sudoers` file to grant sudo privileges to the current user,
/// executes the provided closure, and ensures that the `sudoers` file is restored to its original state
/// regardless of whether the closure succeeds or panics.
///
/// # Errors
///
/// This function returns an error if:
/// - Modifying or restoring the `sudoers` file fails.
/// - The provided action closure returns an error.
///
/// # Example
/// ```rust
/// use dotfiles::modules::cli;
///
/// let result = cli::with_temporary_sudo_privileges(|| {
///     cli::run_command(&["echo", "Hello, world!"], "Failed to echo with sudo")?;
///     Ok(())
/// });
///
/// assert!(result.is_ok());
/// ```
pub fn with_temporary_sudo_privileges<F>(action: F) -> Result<(), Box<dyn std::error::Error>>
where
    F: Fn() -> Result<(), Box<dyn std::error::Error>> + std::panic::RefUnwindSafe,
{
    let username = whoami::username();

    // Backup sudoers.
    run_command(
        &["sudo", "cp", "/etc/sudoers", "/etc/sudoers.bak"],
        "Failed to create backup of sudoers file.",
    )?;

    // Add user to sudoers.
    run_command(
        &[
            "sudo",
            "sh",
            "-c",
            &format!("echo '{} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers", username),
        ],
        "Failed to add user to sudoers file.",
    )?;

    // Function to restore sudoers.
    let restore_sudoers = || -> Result<(), Box<dyn std::error::Error>> {
        run_command(
            &["sudo", "mv", "/etc/sudoers.bak", "/etc/sudoers"],
            "Failed to restore original sudoers file.",
        )?;
        run_command(
            &["sudo", "chmod", "0440", "/etc/sudoers"],
            "Failed to set correct permissions for sudoers file.",
        )?;
        Ok(())
    };

    // Run action.
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(action)).map_err(|_| {
        Box::<dyn std::error::Error>::from("An unexpected panic occurred during action execution.")
    });

    if let Err(e) = restore_sudoers() {
        eprintln!("Failed to restore sudoers: {}", e);
    }

    match result {
        Ok(action_result) => action_result,
        Err(err) => Err(err),
    }
}
