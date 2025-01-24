function wifi
{
sleep -m 2000
$a=netsh wlan show networks | ? {$_ -match 'abc'}
if($re=Invoke-WebRequest -URI http://www.google.com){Write-Host kkk}
#netsh wlan show interface
#netsh wlan disconnect
#Ping 127.0.0.1 -n 2 -w 1000>nul
if($a -ne "a" -and ($a).Contains("abc") -eq "True")
{
    Write-Host hi
    netsh wlan connect ssid=abcdefg name=abcdefg interface="Wi-Fi"
    Write-Host "Signal Strength: " -NoNewline 
    sleep -m 1000
    (netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+',''
    [console]::beep(1000,800)
    break

}
}