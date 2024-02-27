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
#             and 20th July executing "choco upgrade all"
# Definition: choco_auto_update_task.xml
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Get-ScheduledTask -TaskName "Chocolatey Automated Software Update" -ErrorAction SilentlyContinue -OutVariable task > $null

if (!$task) {
    Write-Output "Chocolatey Automated Software Update task is not registered. Registering..."
    schtasks /Create /XML $PSScriptRoot/choco_auto_update_task.xml /TN "JACITA\Chocolatey Automated Software Update"
}

Write-Output "Chocolatey Automated Software Update task registered!"