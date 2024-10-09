param (
  [string]$LinkPath,
  [string]$TargetPath
)

# Check if this script is executed with admin permission.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -LinkPath `"$LinkPath`" -TargetPath `"$TargetPath`"" -Verb RunAs
  exit
}

Write-Host "Creating symlink from $LinkPath to $TargetPath"

# Double-check if the paths are in the correct format
Write-Host "LinkPath: $LinkPath"
Write-Host "TargetPath: $TargetPath"

# Use mklink with cmd.exe
cmd.exe /c mklink "$LinkPath" "$TargetPath"
