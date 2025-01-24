Write-Host "shutdown at full charge SCRIPT"

$monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods


$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(2)
            $port.close()

$monitor.WmiSetBrightness(0,0)
while(1 -eq 1)
{
$a=(Get-CimInstance -Class Win32_Battery).EstimatedChargeRemaining
sleep -m 1000

if($a -gt 100 -or $a -eq 100)
{
    Write-Host ".......................................im  gonna shutdown in 5 mins"
    sleep -m 60000
    $port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)
            $port.close()
    break
}
else
{Write-Host "not yet :("}

}