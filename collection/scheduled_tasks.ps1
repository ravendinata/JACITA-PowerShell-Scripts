# -------------------------------------------------------------------------------------
# Script    : Register JACITA scheduled task(s)
# Author    : Raven Limadinata (JAC IT Team)
# Date      : 2024/02/27
# Rev.      : 1
# Comments  : A script to register all JACITA scheduled task(s). Each new entry must
#             include a header comment to decribe the block.
# Dependency: < check header comment for each registered task >
# -------------------------------------------------------------------------------------

# ENTRIES:

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Task      : Chocolatey Automated Software Update
# Desc.     : Creates a scheduled task that runs twice a year on 10th January
#             and 10th July executing "choco upgrade all"
# Definition: choco_auto_update_task.xml
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Get-ScheduledTask -TaskName "Chocolatey Automated Software Update" -ErrorAction SilentlyContinue -OutVariable task > $null

if (!$task) {
    Write-Output "Chocolatey Automated Software Update task is not registered. Registering..."
    schtasks /Create /XML $PSScriptRoot/choco_auto_update_task.xml /TN "JACITA\Chocolatey Automated Software Update"
}

Write-Output "Chocolatey Automated Software Update task registered!"

# END :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Task      : Semester Disk Clean Up
# Desc.     : Creates a scheduled task that runs twice a year on 10th January
#             and 10th July executing clearmgr (disk cleanup utility)
# Definition: semester_disk_clean_up.xml
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Get-ScheduledTask -TaskName "Semester Disk Clean Up" -ErrorAction SilentlyContinue -OutVariable task > $null

if (!$task) {
    Write-Output "Semester Disk Clean Up task is not registered. Registering..."
    schtasks /Create /XML $PSScriptRoot/semester_disk_clean_up.xml /TN "JACITA\Semester Disk Clean Up"
}

Write-Output "Semester Disk Clean Up task registered!"

# END :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Task      : Monthly Recycle Bin Clean Up
# Desc.     : Creates a scheduled task that runs every month on the 1st day executing
#             the cmdlet Clear-RecycleBin -Force -ErrorAction SilentlyContinue to
#             empty the recycle bin.
# Definition: empty_recycle_bin.xml
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Get-ScheduledTask -TaskName "Monthly Recycle Bin Clean Up" -ErrorAction SilentlyContinue -OutVariable task > $null

if (!$task) {
    Write-Output "Monthly Recycle Bin Clean Up task is not registered. Registering..."
    schtasks /Create /XML $PSScriptRoot/empty_recycle_bin.xml /TN "JACITA\Monthly Recycle Bin Clean Up"
}

Write-Output "Monthly Recycle Bin Clean Up task registered!"

# END :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Task      : Monthly SFC Scan
# Desc.     : Creates a scheduled task that runs every month on the 2nd day executing
#             the cmdlet sfc /scannow to scan and repair system files.
# Definition: monthly_sfc.xml
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Get-ScheduledTask -TaskName "Monthly SFC Scan" -ErrorAction SilentlyContinue -OutVariable task > $null

if (!$task) {
    Write-Output "Monthly SFC Scan task is not registered. Registering..."
    schtasks /Create /XML $PSScriptRoot/monthly_sfc.xml /TN "JACITA\Monthly SFC Scan"
}

Write-Output "Monthly SFC Scan task registered!"

# END :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::