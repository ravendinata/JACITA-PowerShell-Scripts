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

# :::::::::::::::::::::::::::::::
# Check Block Roblox registry key
# :::::::::::::::::::::::::::::::

Write-Host "Block Roblox registry key: " -NoNewline

if (!(Test-Path "collection/Block Roblox.reg")) {
    Write-Host "Missing!" -ForegroundColor Red
    Exit
}
else {
    Write-Host "OK." -ForegroundColor Green
}

# :::::::::::::::::::::::::::::::

# =======
#  MAIN
# =======

# ::::::::::::::::::::::::::::
# Update Group Policy Settings
# ::::::::::::::::::::::::::::

# Only copy group policy settings if Windows edition is Pro
$windowsEdition = (Get-WmiObject -Class Win32_OperatingSystem).OperatingSystemSKU
if ($windowsEdition -eq 48) {
    Write-Host "Copying group policy settings..."
    Copy-Item -Path "$PSScriptRoot\collection\GroupPolicy" -Destination "C:\Windows\System32" -Recurse -Force
    Write-Host "Group policy settings copied!" -ForegroundColor Green
}
else {
    Write-Host "Windows edition is not Pro. Skipping group policy settings copy." -ForegroundColor Yellow
}

# ::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::::
# Import Block Roblox registry key
# ::::::::::::::::::::::::::::::::

Write-Host "Importing Block Roblox registry key..."

# Import registry key
reg import "$PSScriptRoot\collection\Block Roblox.reg"

Write-Host "Block Roblox registry key imported!" -ForegroundColor Green

# ::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::
# Update scheduled tasks
# ::::::::::::::::::::::

& $PSScriptRoot/collection/scheduled_tasks.ps1

# ::::::::::::::::::::::

# :::::::::::::::::::::::::::::::
# Install optional adobe software
# :::::::::::::::::::::::::::::::

& $PSScriptRoot/adobe.ps1

# :::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::
# Install Embarcadero Dev-C++
# :::::::::::::::::::::::::::

Start-Process -FilePath "emb_dcpp.exe" -ArgumentList "/S" -Wait

if ($LASTEXITCODE -eq 0) {
    if (!(Test-Path "C:\Program Files (x86)\Embarcadero\Dev-C++")) {
        Write-Host "Embarcadero Dev-C++ installation failed!" -ForegroundColor Red
        Exit
    }
    else {
        Write-Host "Embarcadero Dev-C++ installed!" -ForegroundColor Green
    }
}
else {
    Write-Host "Embarcadero Dev-C++ installation failed!" -ForegroundColor Red
}

# :::::::::::::::::::::::::::

# =======
#   END
# =======