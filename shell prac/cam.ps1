$ErrorActionPreference="silentlycontinue"
$WIAManager = new-object -comobject WIA.DeviceManager
if (!$?) {
   write "Unable to Create a WIA Object"
   Eexit
}
$DeviceList = $WIAManager.DeviceInfos
if ($DeviceList.Count -gt 0) {
   $Device=$DeviceList.item($DeviceList.Count)
} else {
   write "No Device Connected"
}
$ConnectedDevice = $Device.connect()
if (!$?) {
   write "Unable to Connect to Device"
   
}
$Commands = $ConnectedDevice.Commands
$TakeShot="Not Found"
foreach ($item in $Commands) {
   if ($item.name -match "take") {
       $TakeShot=$x.CommandID
   }
}
if ($TakeShot -eq "Not Found") {
   write "Attached Camera does not provide the ""Take Picture WIA Command"""
   
}