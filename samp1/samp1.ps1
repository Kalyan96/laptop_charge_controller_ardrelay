Write-Host "triggering SCRIPT"
$f=1     #the cycle f=1 charging ccycle f=0 discharging cycle
$high=100
$low=(15+1)
$alert=20
$critic=7

$init=0
$prev=0
$f20=0
$violatef=0
$chrgprev=0
$time=0
$timeprev=0
$rate=0
$date=0
$dateprev=0
$hour=0
$hourprev=0
$lasth=0
$lastm=0
$lasts=0






$a=(Get-CimInstance -Class Win32_Battery).EstimatedChargeRemaining
$ch=(Get-CimInstance -Class Win32_Battery).BatteryStatus     # charging=2 not chrging=1


if($a -gt $high -or $a -eq $high)   #charge is full and still charging
{
$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)#switch off charger
            $port.close()
$f=0}
if($a -lt $high -and $ch -eq 2) #charge is less than full and charger connected
{
$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(2)#switch on
            $port.close()
$f=1}
else                   #charge is less than full and charger not connected
{
$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)#switch off
            $port.close()
$f=0
}


$prev=$a

while(1 -gt 0)#main loop
{
    $a=(Get-CimInstance -Class Win32_Battery).EstimatedChargeRemaining
    $ch=(Get-CimInstance -Class Win32_Battery).BatteryStatus

    if(($a -eq $high -or $a -gt $high) -and $f -eq 1)                                   #charge off (charging ; battery full)
    {
        sleep -m 60000
        if($f -eq 1)
        {
            $port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(1)#charger off
            $port.close()
            $f=0
            $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("REMOVE the charger ....fully charged ",0,"charged up!",0 + 64)}
            
            Write-Host "                                            charged " $a " ! disconnect power"#just a display

        }
    }
    elseif($a -lt $low -and $f -eq 0 )                                                    #charge on ( discharging ; battery low)
    {
        $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("charge left "+$a+"% need to charge !!",0,"low battery",0 + 16)}
        sleep -m 1000
        if($f -eq 0)
        {
            $port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
            $port.open()
            $port.write(2)#switch on the charger 
            $port.close()
            $f=1          #switch to charging cycle
            
            Write-Host "                                            low charge " $a " ! charging......"
        }
    }

    else
    {
        sleep -m 1000

        if($violatef -eq 1 -and $chrgprev -ne $ch)
        {$violatef=0}
        
        $chrgprev=$ch


        if($f -eq 1 -and $ch -eq 2)   # f=1charging cyccle and ch=2 charger on
        {
            Write-Host "charging......"$a "   rate=" ([math]::round(($rate/60))) "min/percent,        time left="$lasth "hours"$lastm "mins to full"
        }

        elseif($f -eq 1 -and $ch -eq 1 -and $violatef -eq 0)   #
        {
           $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("how dare you violate my battery charge policy......its charging cycle !!!",0,"VIOLATION",0 + 48)}
         $violatef=1   # so that it doesnt repeat 
        }

        elseif($f -eq 1 -and $ch -eq 1 -and $a -lt $low)    #when charging is low and charger not connected       
        {
            Write-Host "low charge " $a "% !! connect charger !"
            [console]::beep(2000,800)                       #pitch , time
        }

        elseif($f -eq 0 -and $ch -eq 2 -and $violatef -eq 0)
        {
         $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("how dare you violate my battery charge policy.....its discharging cycle !!!",0,"VIOLATION",0 + 48)}
         $violatef=1
        }

        elseif($f -eq 0 -and $ch -eq 2 -and $a -eq $high)   #when full charged and charger conected 
        {
            Write-Host "charged " $a "% !! remove charger !"
            [console]::beep(2000,100)
        }

        else
        {
            Write-Host "DIScharging......"$a "%   rate=" ([math]::round(($rate/60)))"min/percent,     time left="$lasth "hours"$lastm "mins to death"
            #sleep -m (2*60*1000)
        }

    }



    if($a -eq $alert -and $f20 -eq 0 -and $a -lt $prev)  #show an alert only in the discharging phase for one time
    {$job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("charge left "+$a+"% need to charge !!",0,"low battery",0 + 48)}
        $f20=1 }# this will create a new instance of powershell and then exec this on that powershell so our main program goes uninterrupted



    if($a -ne $alert ){$f20=0} # when the charge decreaases 20 to 19; flag is resetted
    


    if($a -ne $prev)
    {
        $time=Get-Date -format HH:mm:ss
        $tdiff=New-TimeSpan $timeprev $time

        $tdiff1=$tdiff.minutes*60 + $tdiff.seconds   #no of seconds delay
        $rate=($tdiff1)/($a-$prev)

        if($ch -eq 1)  #in discharging state
        {
            $lasts=$rate*$a
            $lasth=[math]::floor($lasts/3600) 
            $lastm=[math]::round(($lasts%3600)/60)
        }

        else
        {
            $lasts=$rate*(100-$a)
            $lasth=[math]::floor($lasts/3600)
            $lastm=[math]::round(($lasts%3600)/60)
        }
        $timeprev=$time 

    }


    if($a -lt $critic -and $ch -eq 1)
    {
     $job = Start-Job -ScriptBlock {$wshell = New-Object -ComObject Wscript.Shell
         $wshell.Popup("BYE!!....i am gonna sleep in a minute",0 + 48)}
         sleep -m 60000
         if((Get-CimInstance -Class Win32_Battery).BatteryStatus -eq 1)
         {
            $PowerState = [System.Windows.Forms.PowerState]::Suspend;
            $Force = $true;
            $DisableWake = $false;
            [System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake);
         }   
    }

    
    
    $prev=$a
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

