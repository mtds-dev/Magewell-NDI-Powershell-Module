function Get-Magewell-Encoder
{
    <#
    .SYNOPSIS
     Retreives information from a Magewell Pro Convert Encoder.     

    .DESCRIPTION
     Retreives information from a Magewell Pro Convert Encoder.     

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
     
    .PARAMETER  EDIDConfiguration
     Use the interface to obtain EDID of input port.

    .PARAMETER  EDIDOutput
     Use the interface to obtain the EDID of output port.

    .PARAMETER  NDIConfiguration
     Use the interface to obtain NDI configurations.

    .PARAMETER  NDISources
     Use the interface to obtain the available backup NDI channels when you configure the failover function.

    .PARAMETER  TallyStatus
     Use the interface to check whether the custom tally is enabled with administrative rights.

    .PARAMETER  PTZConfiguration
     Use the interface to obtain PTZ configurations.

    .PARAMETER  UserInformation
     Use the interface to list all users with administrative rights.

    .PARAMETER  EthernetStatus
     Use the interface to obtain the ethernet status with administrative rights.

    .PARAMETER  EthernetUSBStatus
     Use the interface to obtain the Ethernet over USB status with administrative rights.

    .PARAMETER  NetworkServiceStatus
     Use the interface to get the configuration information of network service, and only the Administrator has the right.

    .PARAMETER  NTPServerStatus
     Use the interface to get the configuration information of NTP service, and only the Administrator has the right.

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
     Outputs JSON object.

    .EXAMPLE
     Get-Magewell-Encoder -IPAddress 10.10.10.10 -UserName Admin -Password $(New-SecureString) -SummaryInformation

     Get-Magewell-Encoder -IPAddress 10.10.10.10 -UserName Admin -Password $(New-SecureString) -RetreiveLogs -LogTypeAll

     Get-Magewell-Encoder -IPAddress 10.10.10.10 -UserName Admin -Password $(New-SecureString) -RetreiveLogs -LogTypeInfo -LogTypeWarn

     Get-Magewell-Encoder -IPAddress 10.10.10.10 -Session $mySession -RetreiveLogs -LogTypeInfo -LogTypeWarn

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

        [Parameter(Mandatory = $true, ParameterSetName = 'EDIDOutput')]
        [Switch]$EDIDOutput,

        [Parameter(Mandatory = $true, ParameterSetName = 'NDIConfiguration')]
        [Switch]$NDIConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'NDISources')]
        [Switch]$NDISources,

        [Parameter(Mandatory = $true, ParameterSetName = 'TallyStatus')]
        [Switch]$TallyStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'PTZConfiguration')]
        [Switch]$PTZConfiguration,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserInformation')]
        [Switch]$UserInformation,

        [Parameter(Mandatory = $true, ParameterSetName = 'EthernetStatus')]
        [Switch]$EthernetStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'EthernetUSBStatus')]
        [Switch]$EthernetUSBStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'NetworkServiceStatus')]
        [Switch]$NetworkServiceStatus,

        [Parameter(Mandatory = $true, ParameterSetName = 'NTPServerStatus')]
        [Switch]$NTPServerStatus,

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
        [string]$IPAddress,

        [Parameter(Mandatory = $false)]
        [string]$UserName = "Admin",

        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session')]
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
        [NDIDeviceModels] $deviceModel = Get-Magewell-NDIDevice-Model  @modelArguments 

        if ($deviceModel -eq [NDIDeviceModels]::Decoder)
        {
            Write-Warning "Device is a Magewell Decoder..."
            Throw "Device is a Decoder, cmdlet is meant for Encoders only."
        }

        Write-Verbose "Magewell Encoder Detected..." 

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
            'EDIDConfiguration'
            { 
                $url = $url +  "get-edid-config"
                break
            }
            'EDIDOutput'
            { 
                $url = $url +  "get-output-edid"
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
            'TallyStatus'
            { 
                $url = $url +  "get-tally"
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
            'NTPServerStatus'
            { 
                $url = $url +  "get-ntp-server"
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
                    ":8070/cloud-api?method=cloud-status&version=1"
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
Export-ModuleMember -Function Get-Magewell-Encoder 
