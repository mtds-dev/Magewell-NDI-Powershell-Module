function Get-Magewell-Decoder
{
    <#
    .SYNOPSIS
     Retreives information from a Magewell Pro Convert Decoder.     

    .DESCRIPTION
     Retreives information from a Magewell Pro Convert Decoder.     

    .PARAMETER  ConnectedProducts
     The specifications vary considerably between different Pro Convert products. Use the interface to get the specifications of the connected product.

    .PARAMETER  AutoReboot
     Use the interface to get the configuration information of auto reboot. 

    .PARAMETER  ResetAllPermissionSettings
     Use the interface to determine whether to provide the reset all settings function to users.
     Only available when the decoder is connected to Ethernet over USB. The reset all settings interface refers to reset-all-settings.

    .PARAMETER  SummaryInformation
     Use the interface to retrieve status and parameters of the Pro Convert device, including device information, Ethernet status, USB RNDIS status, and NDI status.

    .PARAMETER  SignalInformation
     Use the interface to retrieve the input signal information.

    .PARAMETER  VideoConfiguration
     Use the interface to retrieve the video settings.

    .PARAMETER  DefaultVideoConfiguration
     Use the interface to retrieve the default video settings.

    .PARAMETER  SupportedVideoModes
     Use the interface to retrieve video resolutions supported by the presentation device.

    .PARAMETER  VideoFormat
     Use the interface to get the video format.

    .PARAMETER  HDMIOutput
     Use the interface to get the status whether to output after decoding.

    .PARAMETER  AudioConfiguration
     Use the interface to retrieve the audio settings.

    .PARAMETER  EDIDOutput
     Use the interface to obtain the EDID of output port.

    .PARAMETER  ListChannels
     Use the interface to obtain the source list ready to be decoded. The following 2 types are contained.

     The preset sources which are obtained using the list-channels interface.
     The auto-detected NDI sources which are obtained using get-ndi-sources.

    .PARAMETER  SelectedChannels
     Use the interface to obtain selected source name.

    .PARAMETER  BufferLimit
     Use the interface to parse configured buffer duration of each source according to its protocol type, including the default value and the value rang in ms.

    .PARAMETER  NDIConfiguration
     Use the interface to obtain NDI configurations.

    .PARAMETER  NDISources
     Use the interface to obtain the available backup NDI channels when you configure the failover function.

    .PARAMETER  PlaybackConfiguration
     Use the interface to retrieve the playback settings.

    .PARAMETER  TallyStatus
     Use the interface to check whether the custom tally is enabled with administrative rights.

    .PARAMETER  UserInformation
     Use the interface to list all users with administrative rights.

    .PARAMETER  EthernetStatus
     Use the interface to obtain the ethernet status with administrative rights.

    .PARAMETER  EthernetUSBStatus
     Use the interface to obtain the Ethernet over USB status with administrative rights.

    .PARAMETER  NetworkServiceStatus
     Use the interface to get the configuration information of network service, and only the Administrator has the right.

    .PARAMETER  FirmwareStatus
     Use the interface to obtain the current firmware information and update status with administrative rights.

    .PARAMETER  DeviceReport
     Use the interface to get all current conditions of the device with administrative rights.

    .PARAMETER  CloudStatus
     Use the interface to obtain status of the Cloud platforms that your device has registered with.

    .PARAMETER  RetreiveLogs
     Use the interface to obtain the logs as administrator. The device can store up to 1000 local log entries.

    .PARAMETER  LogTypeAll
     Use in conjunction with RetreiveLogs to obtain all logs.

    .PARAMETER  LogTypeInfo
     Use in conjunction with RetrieveLogs to obtain all informational logs.

    .PARAMETER  LogTypeWarn
     Use in conjunction with RetrieveLogs to obtain all warning logs.

    .PARAMETER  LogTypeError
     Use in conjection with RetrieveLogs to obtain all errors logs.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
      Returns a JSON object.    

    .EXAMPLE
     Get-MagewellDecoder -IPAddress 10.10.10.10 -UserName Admin -Password $(New-SecureString) -SummaryInformation

     Get-MagewellDecoder -IPAddress 10.10.10.10 -UserName Admin -Password $(New-SecureString) -RetreiveLogs -LogTypeAll

     Get-MagewellDecoder -IPAddress 10.10.10.10 -UserName Admin -Password $(New-SecureString) -RetreiveLogs -LogTypeInfo -LogTypeWarn

     Get-MagewellDecoder -IPAddress 10.10.10.10 -Session $mySession -RetreiveLogs -LogTypeInfo -LogTypeWarn

    .LINK
     NONE

    .NOTES
     NONE
     #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'SummaryInformation')]
        [Switch]$SummaryInformation,
      
        [Parameter(Mandatory = $true, ParameterSetName = 'AutoReboot')]
        [Switch]$AutoReboot,

        [Parameter(Mandatory = $true, ParameterSetName = 'ResetAllPermissionSettings')]
        [Switch]$ResetAllPermissionSettings,

        [Parameter(Mandatory = $true, ParameterSetName = 'ConnectedProducts')]
        [Switch]$ConnectedProducts,

        [Parameter(Mandatory = $true, ParameterSetName = 'SignalInformation')]
        [Switch]$SignalInformation,

        [Parameter(Mandatory = $true, ParameterSetName = 'VideoConfiguration')]
        [Switch]$VideoConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'DefaultVideoConfiguration')]
        [Switch]$DefaultVideoConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'SupportedVideoModes')]
        [Switch]$SupportedVideoModes,

        [Parameter(Mandatory = $true, ParameterSetName = 'VideoFormat')]
        [Switch]$VideoFormat,

        [Parameter(Mandatory = $true, ParameterSetName = 'HDMIOutput')]
        [Switch]$HDMIOutput,

        [Parameter(Mandatory = $true, ParameterSetName = 'AudioConfiguration')]
        [Switch]$AudioConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'EDIDOutput')]
        [Switch]$EDIDOutput,

        [Parameter(Mandatory = $true, ParameterSetName = 'ListChannels')]
        [Switch]$ListChannels,

        [Parameter(Mandatory = $true, ParameterSetName = 'SelectedChannel')]
        [Switch]$SelectedChannel,

        [Parameter(Mandatory = $true, ParameterSetName = 'BufferLimit')]
        [Switch]$BufferLimit,

        [Parameter(Mandatory = $true, ParameterSetName = 'NDIConfiguration')]
        [Switch]$NDIConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'NDISources')]
        [Switch]$NDISources,

        [Parameter(Mandatory = $true, ParameterSetName = 'PlaybackConfiguration')]
        [Switch]$PlaybackConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'TallyStatus')]
        [Switch]$TallyStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserInformation')]
        [Switch]$UserInformation,

        [Parameter(Mandatory = $true, ParameterSetName = 'EthernetStatus')]
        [Switch]$EthernetStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'EthernetUSBStatus')]
        [Switch]$EthernetUSBStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'NetworkServiceStatus')]
        [Switch]$NetworkServiceStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'FirmwareStatus')]
        [Switch]$FirmwareStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceReport')]
        [Switch]$DeviceReport,

        [Parameter(Mandatory = $true, ParameterSetName = 'CloudStatus')]
        [Switch]$CloudStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeAll')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeInfo')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeWarn')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeError')]
        [Switch]$RetreiveLogs,

        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeAll')]
        [Switch]$LogTypeAll,

        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeInfo')]
        [Switch]$LogTypeInfo,

        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeWarn')]
        [Switch]$LogTypeWarn,

        [Parameter(Mandatory = $true, ParameterSetName = 'LogTypeError')]
        [Switch]$LogTypeError,

        [Parameter(Mandatory = $false)]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false)]
        [Alias("User")]
        [String]$UserName = "Admin",

        [Parameter(Mandatory = $true)]
        [Alias("Pass")]
        [System.Security.SecureString]$Password,

        [Microsoft.PowerShell.Commands.WebRequestSession]$Session
    )
    
    process
    {

        if ($null -eq $Session)
        {
            $SessionArguments = @{
                IPAddress = $IPAddress
                UserName = $UserName
                Password = $Password
            }
            $Session = Invoke-Magewell-NDIDevice-Authentication @sessionArguments 
        }

        if ($null -eq $Session)
        {
            Write-Warning "Authentication failed, command will not be executed."
            return $null
        }

        $modelArguments = @{
            IPAddress = $IPAddress
            UserName = $UserName
            Password = $Password
        }
        [NDIDeviceModels] $deviceModel = Get-Magewell-NDIDevice-Model @modelArguments 

        if ($deviceModel -eq [NDIDeviceModels]::Encoder)
        {
            Write-Warning "Device is a Magewell Encoder..."
            Throw "Device is an Encoder, cmdlet is meant for Decoders only."
        }

        Write-Host "Magewell Decoder Detected..." 

        $url = "http://" + $IPAddress + "/mwapi?method="

        switch ($PSCmdlet.ParameterSetName)
        {
            'SummaryInformation'
            { 
                $url = $url + "get-summary-info"
                break
            }
            'AutoReboot'
            { 
                $url = $url +  "get-auto-reboot"
                break
            }
            'ResetAllPermissionSettings'
            { 
                $url = $url +  "get-reset-all-permission"
                break
            }
            'ConnectedProducts'
            { 
                $url = $url +  "get-caps"
                break
            }
            'SignalInformation'
            { 
                $url = $url +  "get-signal-info"
                break
            }
            'VideoConfiguration'
            { 
                $url = $url +  "get-video-config"
                break
            }
            'DefaultVideoConfiguration'
            { 
                $url = $url +  "get-def-video-config"
                break
            }
            'SupportedVideoModes'
            { 
                $url = $url +  "get-supported-video-modes"
                break
            }
            'VideoFormat'
            { 
                $url = $url +  "get-video-format"
                break
            }
            'HDMIOutput'
            { 
                $url = $url +  "get-video-format"
                break
            }
            'AudioConfiguration'
            { 
                $url = $url +  "get-audio-config"
                break
            }
            'EDIDOutput'
            { 
                $url = $url +  "get-output-edid"
                break
            }
            'ListChannels'
            { 
                $url = $url +  "list-channels"
                break
            }
            'SelectedChannel'
            { 
                $url = $url +  "get-channel"
                break
            }
            'BufferLimit'
            { 
                $url = $url +  "get-buffer-limit"
                break
            }
            'NDIConfiguration'
            { 
                $url = $url +  "get-ndi-config"
                break
            }
            'NDISources'
            { 
                $url = $url +  "get-ndi-sources"
                break
            }
            'PlaybackConfiguration'
            { 
                $url = $url +  "get-playback-config"
                break
            }
            'PTZConfiguration'
            { 
                $url = $url +  "get-ptz-config"
                break
            }
            'UserInformation'
            { 
                $url = $url +  "get-users"
                break
            }
            'EthernetStatus'
            { 
                $url = $url +  "get-eth-status"
                break
            }
            'EthernetUSBStatus'
            { 
                $url = $url +  "get-rndis-status"
                break
            }
            'NetworkServiceStatus'
            { 
                $url = $url +  "get-net-access"
                break
            }
            'FirmwareStatus'
            { 
                $url = $url +  "get-update-state"
                break
            }
            'DeviceReport'
            { 
                $url = $url +  "get-report"
                break
            }
            'CloudStatus'
            { 
                $url = "http://" + $IPAddress + `
                    "/cloud-api?method=cloud-status&version=1"
                break
            }
            'LogTypeAll'
            {
                $url = $url +  "get-logs&types=all"
                break
            }
            'LogTypeInfo'
            {
                $url = $url +  "get-logs&types=info"
                break
            }
            'LogTypeWarn'
            {
                $url = $url +  "get-logs&types=warn"
                break
            }
            'LogTypeError'
            {
                $url = $url +  "get-logs&types=error"
                break
            }
        }

        $argumentList = @{
            Session = $Session 
            URL = $url
            BeginMessage = "Attempting to retrieve the requested information from the device."
            SuccessMessage = "Information retrieved successfully."
            ErrorMessage = "Unable to connect to device."
        }

        if ($PSBoundParameters.ContainsKey('DeviceReport'))
        {
            $argumentList.add("HTMLResponse", $true)
        }

        return Invoke-Magewell-NDIPOSTRequest @argumentList

    }
}
Export-ModuleMember -Function Get-Magewell-Decoder
