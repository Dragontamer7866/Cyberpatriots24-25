@echo off
# warning
echo "Warning, this may not work if not ran in administrator. This may also not work if scripts are disabled."
echo "Warning, this has removed features due to weather or not I belive it will work."

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
Start-MpScan -ScanType fullscan
pause

# finish
curl parrot.live
pause
