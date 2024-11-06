# -------------------------------------------------------------------------------------
# Script    : Laptop WLAN Block/Allow List via netsh
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/11/06
# Rev.      : 1.0.0
# Comments  : Automation script to allow only approved network.
# Dependency: -
# -------------------------------------------------------------------------------------

Write-Host "JAC SCHOOL IT TEAM | WLAN Blocking | v1.0.0" -ForegroundColor Green
Write-Host "Starting WLAN Blocking steps..."

Write-Host "Adding to Allow List..."
netsh wlan add filter permission=allow ssid="JAC Student" networktype=infrastructure
netsh wlan add filter permission=allow ssid="JAC Staff" networktype=infrastructure
netsh wlan add filter permission=allow ssid="JACITA Mobile" networktype=infrastructure

netsh wlan show filters permission=allow

Write-Host "Blocking everything else..."
netsh wlan add filter permission=denyall networktype=infrastructure

Write-Host "Done."