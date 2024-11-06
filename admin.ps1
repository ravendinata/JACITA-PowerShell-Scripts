# -------------------------------------------------------------------------------------
# Script    : Laptop provisioning script - Admin Side
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/07/12
# Rev.      : 1.0.4
# Comments  : Provisions a laptop by performing various tasks to standardize the laptop
#             configuration. To be run on the admin user.
# Dependency: [-] Internet connection to access https://christitus.com/win 
#                 and https://community.chocolatey.org/install.ps1
#             [MSIX] wget.msixbundle -> WinGet package manager installer.
#             [EXE] collection/RR_Rx33/Setup.exe -> Reboot Restore Rx installer.
#             [PS1] collection/scheduled_tasks.ps1 -> PowerShell script to register a 
#                                                     collection of scheduled tasks.
#             [PS1] collection/network.ps1 -> PowerShell Script to setup wireless
#                                             network filtering.
#             [DIR] collection/GroupPolicy -> Group policy settings to be copied.
# -------------------------------------------------------------------------------------

Write-Host "JAC SCHOOL IT TEAM | LAPTOP PROVISIONING SCRIPT | v1.0.2 | Admin Side" -ForegroundColor Green
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
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# ::::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::::
# Check collection/GroupPolicy folder
# :::::::::::::::::::::::::::::::::::

Write-Host "Group Policy settings folder: " -NoNewline

if (!(Test-Path "collection/GroupPolicy")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# :::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::
# Check wget.msixbundle
# :::::::::::::::::::::

Write-Host "WinGet package manager installer: " -NoNewline

if (!(Test-Path "wget.msixbundle")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# :::::::::::::::::::::

# :::::::::::::::::::::::::::::::::
# Check Reboot Restore Rx installer
# :::::::::::::::::::::::::::::::::

Write-Host "Reboot Restore Rx installer: " -NoNewline

if (!(Test-Path "collection/RR_Rx33/Setup.exe")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# :::::::::::::::::::::::::::::::::

# ==========
#   Checks
# ==========

Write-Host "Checking system..."

# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an administrator!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "Running as administrator." -ForegroundColor Green
}

# Check Windows edition
$windowsEdition = (Get-WmiObject -Class Win32_OperatingSystem).OperatingSystemSKU

if ($windowsEdition -eq 48) {
    Write-Host "Windows edition: Pro" -ForegroundColor Green
}
else {
    Write-Host "Windows edition: Not Pro" -ForegroundColor Yellow
}

# Check if WinGet is installed
$winGetExists = Get-Command winget -ErrorAction SilentlyContinue

if ($winGetExists) {
    Write-Host "WinGet is installed." -ForegroundColor Green
}
else {
    Write-Host "WinGet is not installed." -ForegroundColor Yellow
}

# Check if Chocolatey is installed
$chocoExists = Get-Command choco -ErrorAction SilentlyContinue

if ($chocoExists) {
    Write-Host "Chocolatey is installed." -ForegroundColor Green
}
else {
    Write-Host "Chocolatey is not installed." -ForegroundColor Yellow
}

# Check if Student user exists
$studentExists = Get-LocalUser -Name "student" -ErrorAction SilentlyContinue

if ($studentExists) {
    Write-Host "Student user exists." -ForegroundColor Green
}
else {
    Write-Host "Student user does not exist." -ForegroundColor Yellow
}

Write-Host "System checks complete."

# ================
#   Main Process
# ================

Write-Host ""
Write-Host "Starting main process..."

# ::::::::::::::::::::::
# Clean up Adobe folders
# ::::::::::::::::::::::

Write-Host "Cleaning up Adobe setup folders..."

# Cleanup Adobe Illustrator
if (!(Test-Path "C:\JACITA\AAI20")) {
    Write-Host "Adobe Illustrator CC 2020 setup folder not found!" -ForegroundColor Green
}
else {
    Remove-Item "C:\JACITA\AAI20" -r -force
    Write-Host "Removed Adobe Illustrator CC 2020 setup folder." -ForegroundColor Yellow
}

# Cleanup Adobe Photoshop
if (!(Test-Path "C:\JACITA\APS20")) {
    Write-Host "Adobe Photoshop CC 2020 setup folder not found!" -ForegroundColor Green
}
else {
    Remove-Item "C:\JACITA\APS20" -r -force
    Write-Host "Removed Adobe Photoshop CC 2020 setup folder." -ForegroundColor Yellow
}

Write-Host "Finished cleaning up Adobe setup folders."

# ::::::::::::::::
# SSH Server Setup
# ::::::::::::::::

Write-Host ""

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
# Update WinGet
# :::::::::::::

Write-Host ""
Write-Host "Updating WinGet..."
Add-AppxPackage -Path wget.msixbundle
Write-Host "WinGet updated." -ForegroundColor Green

# :::::::::::::

# :::::::::::::
# Install choco
# :::::::::::::

Write-Host ""

if ($chocoExists) {
    Write-Host "Chocolatey is already installed. Skipping..." -ForegroundColor Yellow
}
else {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy AllSigned
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host "Chocolatey installed!" -ForegroundColor Green
}

# :::::::::::::

# :::::::::::::::::::::::::::::::::
# Setup Microsoft Defender Settings
# :::::::::::::::::::::::::::::::::

Write-Host ""
Write-Host "Setting up Microsoft Defender settings..."
Set-MpPreference -QuarantinePurgeItemsAfterDelay 30
Set-MpPreference -ScanScheduleQuickScanTime 06:45:00
Write-Host "Microsoft Defender settings set!" -ForegroundColor Green

# :::::::::::::::::::::::::::::::::

# :::::::::::::::
# Start CTT tweak
# :::::::::::::::

Write-Host ""
Write-Host "Starting CTT tweaker..." -ForegroundColor Magenta
Invoke-WebRequest -useb https://christitus.com/win | Invoke-Expression

# :::::::::::::::

# :::::::::::::::::::
# Create Student user
# :::::::::::::::::::

Write-Host ""

if ($studentExists) {
    Write-Host "Student user already exists. Skipping..." -ForegroundColor Yellow
}
else {
    Write-Host "Creating Student user..." 
    # Create the Local User "student"
    New-LocalUser -Name "student" -FullName "Student" -Description "Student access account" -UserMayNotChangePassword -NoPassword | Set-LocalUser -PasswordNeverExpires $true

    # Assign student local user to "Users" group
    Add-LocalGroupMember -Group "Users" -Member "student"

    Write-Host "Student user created!" -ForegroundColor Green
}

# ::::::::::::::::::::::::::::::::
# Setup Wireless Network Filtering
# ::::::::::::::::::::::::::::::::

& $PSScriptRoot/collection/network.ps1

# :::::::::::::::::::::
# Scheduled tasks setup
# :::::::::::::::::::::

& $PSScriptRoot/collection/scheduled_tasks.ps1

# :::::::::::::::::::::

# ::::::::::::::::::::::::::
# Copy group policy settings
# ::::::::::::::::::::::::::

# Only copy group policy settings if Windows edition is Pro
if ($windowsEdition -eq 48) {
    Write-Host "Copying group policy settings..."
    Copy-Item -Path "$PSScriptRoot\collection\GroupPolicy" -Destination "C:\Windows\System32" -Recurse -Force
    Write-Host "Group policy settings copied!" -ForegroundColor Green
}
else {
    Write-Host "Windows edition is not Pro. Skipping group policy settings copy." -ForegroundColor Yellow
}

# ::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::::::::::::::
# Shrink the disk and create a new partition
# ::::::::::::::::::::::::::::::::::::::::::

Write-Host ""
Write-Host "Shrinking the disk and creating a new partition..."

# Shrink Volume C:
$cdisk_size = Get-PartitionSupportedSize -DriveLetter C
Resize-Partition -DriveLetter C -Size ($cdisk_size.SizeMax - 16GB)

# Create a new partition
New-Partition -DiskNumber 0 -UseMaximumSize -AssignDriveLetter -DriveLetter Z


# :::::::::::::::::::::::::::::::
# Run Reboot Restore Rx installer
# :::::::::::::::::::::::::::::::

Write-Host ""
Write-Host "Running Reboot Restore Rx installer..."
Start-Process -FilePath "$PSScriptRoot\collection\RR_Rx33\Setup.exe" -ArgumentList "/S" -Wait
Write-Host "Reboot Restore Rx installed!" -ForegroundColor Green

# :::::::::::::::::::::::::::::::

# =======
#   END
# =======

Write-Host "Admin-side laptop provisioning process is done!"
Write-Host "Please proceed to sign-in as Student and start the student-side laptop provisioning process."