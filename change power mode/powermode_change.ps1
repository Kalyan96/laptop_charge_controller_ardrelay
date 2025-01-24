$pre=( Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
$ee=Get-WmiObject -Namespace root\cimv2\power -Class win32_PowerPlan | Select-Object -Property IsActive | Out-String
$p=$ee.IndexOf('T')
if( $p -eq 26)#in balanced
{
    $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'High Performance'"          
    Invoke-CimMethod -InputObject $p -MethodName Activate
     $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("I'm HIGH",2,"HIGHPOWER",64)}
}
if( $p -eq 36)#in high
{
    $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'Power Saver'"          
    Invoke-CimMethod -InputObject $p -MethodName Activate
    $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("Saving power",2,"POWERSAVER",64)}
}
if( $p -eq 46)#in save
{
    $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'Balanced'"          
    Invoke-CimMethod -InputObject $p -MethodName Activate
    $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("trying to balance",2,"BALANCING",64)}
}
$monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
if($pre -gt 50)
{
    $monitor.WmiSetBrightness(0,0)
    sleep -m 500
    $monitor.WmiSetBrightness(0,$pre)
}
else
{
    $monitor.WmiSetBrightness(0,100)
    sleep -m 500
    $monitor.WmiSetBrightness(0,$pre)
}