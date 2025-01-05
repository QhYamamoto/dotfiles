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
