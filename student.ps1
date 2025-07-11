# -------------------------------------------------------------------------------------
# Script    : Laptop provisioning script - Admin Side
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/02/27
# Rev.      : 1.0.2
# Comments  : Provisions a laptop by performing various tasks to standardize the laptop
#             configuration. To be run on the student user.
# Dependency: [CFG] collection/packages.config -> A list of software to install.
# -------------------------------------------------------------------------------------

Write-Host "JAC SCHOOL IT TEAM | LAPTOP PROVISIONING SCRIPT | v1.0.1 | Student Side" -ForegroundColor Magenta
Write-Host "Starting Laptop Provisioning Script..."

# =====================
#   Dependency checks
# =====================

Write-Host "Checking dependencies..."

# ::::::::::::::::::::::::::::::::
# Check collection/packages.config
# ::::::::::::::::::::::::::::::::

Write-Host "Choco install manifest: " -NoNewline

if (!(Test-Path "collection/packages.config")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# ::::::::::::::::::::::::::::::::

# ================
#   Main Process
# ================

# ::::::::::::::::::::::::::::::::::
# Remove Windows Store on student side
# ::::::::::::::::::::::::::::::::::

Write-Host "Removing Microsoft Store (Student)"
Get-AppxPackage *windowsstore* | Remove-AppxPackage
Write-Host "Microsoft Store removed!"

# ::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::
# Setup Microsoft Defender Settings
# :::::::::::::::::::::::::::::::::

Set-MpPreference -QuarantinePurgeItemsAfterDelay 30
Set-MpPreference -ScanScheduleQuickScanTime 06:45:00

# :::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::::::::::::::::::
# Install essential software package using choco
# ::::::::::::::::::::::::::::::::::::::::::::::

Write-Host "Installing essential software package via choco"
choco install collection/packages.config --yes
Write-Host "Choco bulk install done!"

# ::::::::::::::::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::
# Run network filtering script
# ::::::::::::::::::::::::::::

Write-Host "Running network filtering script..."
Start-Process -FilePath "$PSScriptRoot\collection\network.ps1" -Wait
Write-Host "Network filtering script executed!"

# =======
#   END
# =======

Write-Host "Student-side laptop provisioning process is done!"