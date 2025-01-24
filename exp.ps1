Get-ChildItem -Path $home\* -Include *.ps1 -Recurse
sleep -s 10
$port= new-Object System.IO.Ports.SerialPort COM3,9600,No
ne,8,one
$port.open()
$port.write(1)
sleep -s 5
$port.write(2)
pause
