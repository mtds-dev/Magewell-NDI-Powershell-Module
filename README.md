# BASIC USE  
To begin using the Magewell Powershell Module start by downloading or clone the repo to a location such as your desktop folder.  If you download, in lieu of cloning, you'll need to extract the module from the zip file.  

Open Powershell and browse to the folder where you downloaded\extracted the module.  

```
cd ~/Desktop/magewell  
```

Next you will need to import the Magewell module to have access to the various commands.  This needs to be done each time you open powershell or you'll need to place the module in your modules path.  
```
Import-Module ./Magewell.psd1  
```

After successfully importing the Magewell module you can use these help commands to learn more:

<b> List all available commands. </b>  
```
Get-Command -Module magewell  
```

<b> List all commands associated with encoders. </b>  
```
Get-Command -Module Magewell | where {$_.Name -Match "Encoder"}
```

<b>  List all commands associated with decoders </b>  
```
Get-Command -Module Magewell | where {$_.Name -Match "Decoder"}
```

<b> List all commands that are agnostic in nature. </b>  
```
Get-Command -Module Magewell | where {$_.Name -Match "NDIDevice"}
```

<b> Getting help with individual commands. </b>  
```
help Get-Magewell-Encoder  
 or
help Get-Magewell-Decoder  
```
# PASSWORD MANAGEMENT
<b> Being prompted for your password. </b>
```
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $(New-SecureString) -SummaryInformation
```

<b> Being prompted for your password each time a command executes. </b>
```
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $(New-SecureString) -SummaryInformation
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $(New-SecureString) -AutoReboot
```

<b> Being prompted only once for your password but reusing the password for multiple commands. </b>
```
$myPassword = $(New-SecureString)
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $myPassword -SummaryInformation
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $myPassword -AutoReboot
```

<b> Providing a password without being prompted. </b>
```
$myPassword = ConvertTo-SecureString -String "myPassword"
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $(New-SecureString) -SummaryInformation
Get-Magewell-Decoder -IPAddress "192.168.0.10" -UserName "Admin" -Password $(New-SecureString) -AutoReboot
```

# SESSION MANAGEMENT 
Instead of reauthenticating to the device each time, you can pass "sessions" around. Doing so is a lot faster in comparison when running a lot of commands on many devices.
```
$session = Invoke-Magewell-NDIDevice-Authentication -IPAddress "192.168.0.10" -UserName "Admin" -Password $(New-SecureString)
Get-Magewell-Decoder -IPAddress "192.168.0.10" -Session $session  -SummaryInformation
Get-Magewell-Decoder -IPAddress "192.168.0.10" -Session $session  -AutoReboot
```

# DECODERS
<b> Get-Magewell-Decoder</b>  
Use this command to retreive information about a Magewell Pro Convert Decoder.  

<b>Set-Magewell-Decoder-AudioConfiguration</b>  
Use this command to modify audio settings.

<b>Set-Magewell-Decoder-NDIConfiguration</b>  
Use this command to modify NDI settings.

<b>Set-Magewell-Decoder-PlaybackConfiguration</b>  
Use this command to modify playback settings.

<b>Set-Magewell-Decoder-VideoConfiguration</b>  
Use this command to modify video settings.

<b>Set-Magewell-Decoder-VideoFormat</b>  
Use this command to modify video format settings.

<b>Set-Magewell-Decoder-VideoMode</b>  
Use this command to modify video resolution, signal, fieldrate, and aspectratio.

<b>Set-Magewell-Decoder-Channel</b>  
Use this command to select current stream source.

<b>Add-Magewell-Decoder-Channel</b>  
Use this command to add new channels.

<b>Clear-Magewell-Decoder-Channel</b>  
Use this command to clear all listed channels

<b>Edit-Magewell-Decoder-Channel</b>  
Use this command  to modify channel name and/or source url.

# ENCODERS
<b>Get-Magewell-Encoder</b>  
Use this command to retreive inforamtion from a Magewell Pro Convert Encoder.

<b>Invoke-Magewell-Encoder-EDIDConfigurationReset</b>  
Use this command to reset the current EDID settings.

<b>Invoke-Magewell-Encoder-EDIDExport</b>  
Use this command to export EDID configuration to a bin file.

<b>Invoke-Magewell-Encoder-EDIDUpload</b>  
Use this command to import EDID configuration from a bin file.

<b>Invoke-Magewell-Encoder-NDIFailover</b>  
Use this command to configure failover options for NDI.

<b>Invoke-Magewell-Encoder-NDIReceiverControl</b>  
Use this command to enable/disable PTZ control or web control in NDI Studio Monitor.

<b>Invoke-Magewell-Encoder-NDISourceVideo</b>  
Use this command to set NDI Configurations.

<b>Invoke-Magewell-Encoder-NDITally</b>  
Use this command to enable custom tally with administrative rights.

<b>Invoke-Magewell-Encoder-PTZArrangeCameras</b>  
Use the command to effect PTZ settings.

<b>Invoke-Magewell-Encoder-PTZConfiguration</b>  
Use the command to set PTZ parameters.

<b>Set-Magewell-Encoder-EDIDConfiguration</b>  
Use the command to modify EDID of input port.

<b>Set-Magewell-Encoder-NDIAudioReferenceLevel</b>  
Use the command to change NDI Audio levels.  SMPTE: 20 and EBU: 14

<b>Set-Magewell-Encoder-NDIDiscoveryServer</b>  
Use this command to configure NDI's discovery server.

<b>Set-Magewell-Encoder-NDIService</b>  
Use this command to set NDI configurations.

<b>Set-Magewell-Encoder-NDITransitionMode</b>  
Use this command to enable/disable multicast, RUDP, TCP, UDP transmission modes for NDI.

<b>Set-Magewell-Encoder-NDIVendor</b>  
Use this command to set the NDI Vendor Name and ID.

<b>Set-Magewell-Encoder-NetworkNTPServer</b>  
Use this command to configure NTP service, must have administrative permissions.

<b>Set-Magewell-Encoder-VideoConfiguration</b>  
Use this command to change video configurations such as brightness, contrast, saturdation, deinterlace, and others parameters.


# AGNOSTIC
<b>Add-Magewell-NDIDevice-User</b>  
Use this command to add user accounts.

<b>Clear-Magewell-NDIDevice-Logs</b>  
Use this command to clear all logs on a device.

<b>Edit-Magewell-NDIDevice-UserPassword</b>  
Use this command to change a user's password.

<b>Get-Magewell-NDIDevice-CloudStatus</b>  
Use this command to check cloud status.

<b>Get-Magewell-NDIDevice-Model</b>  
Use this command to check a device model. Returns an enum of [NDIDeviceModels]::Encoder or [NDIDeviceModels]::Decoder

<b>Initialize-Magewell-NDIDevice</b>  
Use this command to initialize a new Magewell device.

<b>Initialize-Magewell-NDIDevices</b>  
Use this command to initialize and configure multiple new magewell devices. 

<b>Invoke-Magewell-NDIDevice-Authentication</b>  
Use this command if you want to authenticate to a device.  This isn't needed for any other commands, as they will handle authentication for you.

<b>Invoke-Magewell-NDIDevice-CloudRegistration</b>  
Use this command to register device with the Cloud.

<b>Invoke-Magewell-NDIDevice-CloudUnregister</b>  
Use this command to unregister device with the Cloud.

<b>Invoke-Magewell-NDIDevice-Firmware-Upgrade</b>  
Use this command to upgrade a device's firmware.

<b>Invoke-Magewell-NDIDevice-Firmware-Update</b>  
Use this command after uploading the file. (Only use if creating a custom firmware update script.)

<b>Invoke-Magewell-NDIDevice-Firmware-UploadFile</b>  
Use this command to upload the firmware file. (Only use if creating a custom firmware update script.)

<b>Get-Magewell-NDIDevice-Firmware-State</b>  
Use this command to get the current state of the firmware.  Current version or the status of a firmware update.

<b>Invoke-Magewell-NDIDevice-ResetAllSettings</b>  
Use this command to reset all device settings.

<b>Invoke-Magewell-NDIDevice-ResetVideoConfig</b>  
Use this command to reset only video configuration settings.

<b>Invoke-Magewell-NDIDevice-SSLCertificate-Upload</b>  
*NOT CURRENTLY WORKING.

<b>Invoke-Magewell-NDIDevice-SSLCertKey-Upload</b>  
*NOT CURRENTLY WORKING.

<b>Invoke-Magewell-NDIDevice-Utilities</b>  
Use this command to either reboot, check online status, sync-time, or schedule auto-reboots of the device.

<b>New-Magewell-NDIDeviceTemplate</b>  
Use this command to create a template file that can be used in conjunction with Initialize-Magwell-NDIDevices.

<b>Remove-Magewell-NDIDevice-User</b>  
Use this command to remove user accounts.

<b>Set-Magewell-NDIDevice-NetworkAccess</b>  
Use this command to enable/disable SSDP/HTTPS on the device.

<b>Set-Magewell-NDIDevice-NetworkConfiguration</b>  
Use this command to set ethernet configuration settings.

<b>Set-Magewell-NDIDevice-RNDISConfiguration</b>  
Use this command to configure the USB network settings.

<b>Set-Magewell-NDIDevice-UserPassword</b>  
Use this command to reset a user's password.
