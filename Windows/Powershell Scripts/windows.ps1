@echo off
title 'Windows Script'
# warning
echo "Warning, this may not work if not ran in administrator. This may also not work if scripts are disabled."

# Execution Policy
Get-ExecutionPolicy
$Execution = Get-ExecutionPolicy

if (Restricted -eq $Execution)
{
    echo 'Go open a terminal and type "Set-ExecutionPolicy Unrestricted" then execute this script again.'
    pause
    exit
}

# users
Get-LocalUser
$CurrentUser = Whoami

# wp status
Get-MpComputerStatus
Set-MpPreference -DisableRealtimeMonitoring $false
Update-MpSignature

# firewall
Get-NetFirewallProfile
Set-NetFirewallProfile -Enabled True -Profile Domain, Private, Public
New-NetFirewallRule -DisplayName "Block RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Block

# Local Security Policy
net accounts /maxpwage:31
net accounts /minpwage:21
net accounts /minpwlen:12
net accounts /lockoutduration:30
net accounts /lockoutthreshold:5
net accounts

# services
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# quick virus scan
Start-MpScan -ScanType Fullscan

# windows updates
wuauclt /detectnow
echo "Please type: wuauclt /updatenow    after the script finishes"
pause

# finish
curl parrot.live
pause
