# -------------------------------------------------------------------------------------
# Script    : Optional Adobe Products Installation Script
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/07/25
# Rev.      : 1.0.0
# Comments  : Installs optional Adobe products for students.
# Dependency: [EXE] adobe/ALC19/Set-up.exe -> Adobe Lightroom Classic 2019
#             [EXE] adobe/AAE24/Set-up.exe -> Adobe After Effects 2024
#             [EXE] adobe/APP24/Set-up.exe -> Adobe Premiere Pro 2024
# -------------------------------------------------------------------------------------

# ======================
#   Check Dependencies
# ======================

Write-Host "Checking dependencies..."

# ::::::::::::::::::::::::::::::::::
# Check Adobe Lightroom Classic 2019
# ::::::::::::::::::::::::::::::::::

Write-Host "Adobe Lightroom Classic 2019: " -NoNewline

if (!(Test-Path "adobe/ALC19/Set-up.exe")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# ::::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::
# Check Adobe After Effects 2024
# ::::::::::::::::::::::::::::::

Write-Host "Adobe After Effects 2024: " -NoNewline

if (!(Test-Path "adobe/AAE24/Set-up.exe")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# ::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::
# Check Adobe Premiere Pro 2024
# :::::::::::::::::::::::::::::

Write-Host "Adobe Premiere Pro 2024: " -NoNewline

if (!(Test-Path "adobe/APP24/Set-up.exe")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# :::::::::::::::::::::::::::::

# ================
#   Main Process
# ================

# ::::::::::::::::::::::::::::::::::::
# Install Adobe Lightroom Classic 2019
# ::::::::::::::::::::::::::::::::::::

Write-Host "Installing Adobe Lightroom Classic 2019…"

Start-Process -FilePath "adobe/ALC19/Set-up.exe" -ArgumentList "/S" -Wait

if ($LASTEXITCODE -eq 0) {
    if (!(Test-Path "C:\Program Files\Adobe\Adobe Lightroom Classic CC")) {
        Write-Host "Adobe Lightroom Classic 2019 installation failed!" -ForegroundColor Red
        Exit
    }
    else {
        Write-Host "Adobe Lightroom Classic 2019 installed!" -ForegroundColor Green
    }
    Write-Host "Adobe Lightroom Classic 2019 installed!" -ForegroundColor Green
}
else {
    Write-Host "Adobe Lightroom Classic 2019 installation failed!" -ForegroundColor Red
}

# ::::::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::::
# Install Adobe After Effects 2024
# ::::::::::::::::::::::::::::::::

Write-Host "Installing Adobe After Effects 2024…"

Start-Process -FilePath "adobe/AAE24/Set-up.exe" -ArgumentList "/S" -Wait

if ($LASTEXITCODE -eq 0) {
    if (!(Test-Path "C:\Program Files\Adobe\Adobe After Effects 2024")) {
        Write-Host "Adobe After Effects 2024 installation failed!" -ForegroundColor Red
        Exit
    }
    else {
        Write-Host "Adobe After Effects 2024 installed!" -ForegroundColor Green
    }
}
else {
    Write-Host "Adobe After Effects 2024 installation failed!" -ForegroundColor Red
}

# :::::::::::::::::::::::::::::::
# Install Adobe Premiere Pro 2024
# :::::::::::::::::::::::::::::::

Write-Host "Installing Adobe Premiere Pro 2024…"

Start-Process -FilePath "adobe/APP24/Set-up.exe" -ArgumentList "/S" -Wait

if ($LASTEXITCODE -eq 0) {
    if (!(Test-Path "C:\Program Files\Adobe\Adobe Premiere Pro 2024")) {
        Write-Host "Adobe Premiere Pro 2024 installation failed!" -ForegroundColor Red
        Exit
    }
    else {
        Write-Host "Adobe Premiere Pro 2024 installed!" -ForegroundColor Green
    }
}
else {
    Write-Host "Adobe Premiere Pro 2024 installation failed!" -ForegroundColor Red
}

# :::::::::::::::::::::::::::::::

# ========
#   POST
# ========

# Clean up the installation files
Write-Host "Cleaning up installation files…"
Remove-Item -Path "adobe" -Recurse -Force

if (Test-Path "adobe") {
    Write-Host "Failed to clean up installation files! Please manually clean up the installation files." -ForegroundColor Red
}
else {
    Write-Host "Installation files cleaned up!" -ForegroundColor Green
}

# End of script