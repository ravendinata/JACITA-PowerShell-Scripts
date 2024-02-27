# -------------------------------------------------------------------------------------
# Script    : Laptop provisioning script - Admin Side
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/02/27
# Rev.      : 1.0.0
# Comments  : Provisions a laptop by performing various tasks to standardize the laptop
#             configuration. To be run on the student user.
# Dependency: [CFG] collection/packages.config -> A list of software to install.
# -------------------------------------------------------------------------------------

Write-Host "JAC SCHOOL IT TEAM | LAPTOP PROVISIONING SCRIPT | v1.0.0 | Student Side" -ForegroundColor Magenta
Write-Host "Starting Laptop Provisioning Script..."

# =====================
#   Dependency checks
# =====================

Write-Host "Checking dependencies..."

# ::::::::::::::::::::::::::::::::
# Check collection/packages.config
# ::::::::::::::::::::::::::::::::

if (!(Test-Path "collection/packages.config")) {
    Write-Host "Choco install manifest is missing! Aborting."
    Exit
}
else {
    Write-Host "Exists: Choco install manifest"
}

# ::::::::::::::::::::::::::::::::

# ================
#   Main Process
# ================

# ::::::::::::::::::::::::::::::::::
# Remove Windows Store on admin side
# ::::::::::::::::::::::::::::::::::

Write-Host "Removing Microsoft Store (Student)"
Get-AppxPackage *windowsstore* | Remove-AppxPackage
Write-Host "Microsoft Store removed!"

# ::::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::::::::::::::::::
# Install essential software package using choco
# ::::::::::::::::::::::::::::::::::::::::::::::

Write-Host "Installing essential software package via choco"
choco install collection/packages.config
Write-Host "Choco bulk install done!"

# ::::::::::::::::::::::::::::::::::::::::::::::

# =======
#   END
# =======

Write-Host "Student-side laptop provisioning process is done!"