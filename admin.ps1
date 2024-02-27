# -------------------------------------------------------------------------------------
# Script    : Laptop provisioning script - Admin Side
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/02/27
# Rev.      : 1.0.0
# Comments  : Provisions a laptop by performing various tasks to standardize the laptop
#             configuration. To be run on the admin user.
# Dependency: [-] Internet connection to access https://christitus.com/win
#             [PS1] collection/scheduled_tasks.ps1 -> PowerShell script register a 
#                                                     collection of scheduled tasks.
# -------------------------------------------------------------------------------------

Write-Host "JAC SCHOOL IT TEAM | LAPTOP PROVISIONING SCRIPT | v1.0.0 | Admin Side" -ForegroundColor Green
Write-Host "Starting Laptop Provisioning Script..."

# =====================
#   Dependency checks
# =====================

Write-Host "Checking dependencies..."

# ::::::::::::::::::::::::::::::::::::
# Check collection/scheduled_tasks.ps1
# ::::::::::::::::::::::::::::::::::::

Write-Host "Scheduled Tasks Register script: " -NoNewline

if (!(Test-Path "collection/scheduled_tasks.ps1")) {
    Write-Host "Missing!"
    Exit
}
else {
    Write-Host "OK."
}

# ::::::::::::::::::::::::::::::::::::

# ================
#   Main Process
# ================

# ::::::::::::::::::::::::::::::::::
# Remove Windows Store on admin side
# ::::::::::::::::::::::::::::::::::

Write-Host "Removing Microsoft Store (Admin)"
Get-AppxPackage *windowsstore* | Remove-AppxPackage
Write-Host "Microsoft Store removed!"

# ::::::::::::::::::::::::::::::::::

# ::::::::::::::::
# SSH Server Setup
# ::::::::::::::::

# Enable SSH
Write-Host "Enabling SSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Write-Host "SSH Server enabled!"

# Set SSH to autostart on boot
Write-Host "Setting up SSH auto start..."
Set-Service -Name sshd -StartupType 'Automatic'
Write-Host "SSH set to auto start!"

# ::::::::::::::::

# :::::::::::::
# Install choco
# :::::::::::::

Write-Host "Installing Chocolatey..."
winget install --id chocolatey.chocolatey --source winget
Write-Host "Chocolatey installed!"

# :::::::::::::

# :::::::::::::::
# Start CTT tweak
# :::::::::::::::

Write-Host "Starting CTT tweaker..."
Invoke-WebRequest -useb https://christitus.com/win | Invoke-Expression

# :::::::::::::::

# :::::::::::::::::::
# Create Student user
# :::::::::::::::::::

# Create the Local User "student"
New-LocalUser -Name "student" -FullName "Student" -Description "Student access account" -UserMayNotChangePassword -NoPassword | Set-LocalUser -PasswordNeverExpires $true

# Assign student local user to "Users" group
Add-LocalGroupMember -Group "Users" -Member "student"

# Setup all scheduled tasks
& $PSScriptRoot/collection/scheduled_tasks.ps1

# =======
#   END
# =======

Write-Host "Admin-side laptop provisioning process is done!"
Write-Host "Please proceed to sign-in as Student and start the student-side laptop provisioning process."