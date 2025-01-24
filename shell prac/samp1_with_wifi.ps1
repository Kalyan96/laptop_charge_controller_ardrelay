Write-Host "triggering SCRIPT"
$f=1
$high=100
$low=(10+1)
$alert=20
$init=0
$prev=0


function wific #wifi check and connect func
{
sleep -m 2000
$a=netsh wlan show networks | ? {$_ -match 'abc'}
$job = Start-Job -ScriptBlock {$re=Invoke-WebRequest -URI http://www.google.com}
if($a -ne "a" -and ($a).Contains("abc") -eq "True")
{
    netsh wlan connect ssid=abcdefg name=abcdefg interface="Wi-Fi"
    sleep -m 1000
    if((netsh wlan show interfaces) -Match '^\s+State' -Replace '^\s+State\s+:\s+','' -eq "connected")
    {
    Write-Host "Signal Strength: " -NoNewline 
    (netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+',''
    [console]::beep(1000,800)
    }
    else
    {Write-Host " wifi unable to connect...........need to refresh :'( " }
    

}
}


$a=(Get-CimInstance -Class Win32_Battery).EstimatedChargeRemaining
$ch=(Get-CimInstance -Class Win32_Battery).BatteryStatus
if($a -gt $high -or $a -eq $high)
{
$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)
            $port.close()
$f=0}
if($a -lt $high -and $ch -eq 2)
{
$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(2)
            $port.close()
$f=1}
else
{
$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)
            $port.close()
$f=0
}
$prev=$a

while(1 -gt 0)#main loop
{
    $a=(Get-CimInstance -Class Win32_Battery).EstimatedChargeRemaining
    $ch=(Get-CimInstance -Class Win32_Battery).BatteryStatus
    if(($a -eq $high -or $a -gt $high) -and $f -ne 0)#charge off
    {
        sleep -m (2*60000)
        if($f -ne 0)
        {
            $port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)
            $port.close()
            $f=0
            $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("REMOVE the charger ....charge complete",0,"charged up!",0 + 64)}
            
            Write-Host "                                            charged " $a " ! disconnect power"

        }
    }
    elseif($a -lt $low -and $f -ne 1 )#charge on
    {
        $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("charge left "+$a+"% need to charge !!",0,"low battery",0 + 16)}
        sleep -m 1000
        if($f -ne 1)
        {
            $port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(2)
            $port.close()
            $f=1
            
            Write-Host "                                            low charge " $a " ! charging......"
        }
    }
    else
    {
        sleep -m 1000
        if($f -eq 1 -and $ch -eq 2)
        {
            Write-Host "charging......"$a
        }
        elseif($f -eq 1 -and $ch -eq 1 -and $a -lt $low )
        {
            Write-Host "low charge " $a "% !! connect charger !"
            [console]::beep(2000,800)
        }
        elseif($f -eq 0 -and $ch -eq 2 )
        {
            Write-Host "charged " $a "% !! remove charger !"
            [console]::beep(2000,100)
        }
        else
        {
            Write-Host "DIScharging......"$a
            #sleep -m (2*60*1000)
        }

    }


    if($a -eq $alert)
    {$job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("charge left "+$a+"% need to charge !!",0,"low battery",0 + 48)}}# this will create a new instance of powershell and then exec this on that powershell so our main program goes uninterrupted
    
    $b=((netsh wlan show interfaces) -Match '^\s+State' -Replace '^\s+State\s+:\s+','')
    if($b -ne "connected")
    {wific}
    #if($prev -eq $a)
    #{
   #     $ti=(((get-date).minute*60000)+((get-date).second*1000)+((get-date).millisecond))/1000
  #      $diff=$ti-$tiprev
 #       $tiprev=$ti
#        $rate=1/$ti
    #}
    #else
    #{$prev=$a}

}

