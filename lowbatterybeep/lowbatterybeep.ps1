Write-Host "MONITORING SCRIPT"
while(1)
{
    #$ch=(Get-CimInstance -Class Win32_Battery).BatteryStatus
    $a=(Get-CimInstance -Class Win32_Battery).EstimatedChargeRemaining
    if($a -lt 33 )#-and $ch -ne 2)
    {
         [console]::beep(2000,500)
         $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("charge left "+$a+"% need to charge !!",0,"low battery",0 + 48)}
         #$wshell = New-Object -ComObject Wscript.Shell
         #$wshell.Popup("charge left "+$a+"% need to charge !!",0,"low battery",0 + 16)# 48 yelow 16 red
    }
}