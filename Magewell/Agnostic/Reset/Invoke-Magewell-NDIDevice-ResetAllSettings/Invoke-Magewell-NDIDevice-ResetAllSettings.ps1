function Invoke-Magewell-NDIDevice-ResetAllSettings
{
    <#
    .SYNOPSIS
     Use the interface to reset all settings back to default.

     Only available when the device is connected to Ethernet over USB.

     The reset process may take a few minutes, and all configuration data will be lost. After resetting, the device will restart, you can use the ping interface to check the device state 

    .DESCRIPTION
     Use the interface to reset all settings back to default.

     Only available when the device is connected to Ethernet over USB.

     The reset process may take a few minutes, and all configuration data will be lost. After resetting, the device will restart, you can use the ping interface to check the device state

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
     Password for the device

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     NONE

    .EXAMPLE
     Invoke-Magewell-NDIDevice-ResetAllSettings -IPAddress 10.10.10.10 -UserName Admin -Password myPassword 

     Invoke-Magewell-NDIDevice-ResetAllSettings -IPAddress 10.10.10.10 -Session $mySession

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("User")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $false, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $true, ParameterSetName = 'New-Session')]
        [Alias('Pass')]
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
            Write-Host "Authentication failed, command will not be executed."
            return $null
        }

        $url = "http://" + $IPAddress + "/mwapi?method=reset-all-settings"
        
        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to reset device."
            SuccessMessage = "Action taken successfully, reset may take up to two minutes, please do not turn off your device."
            ErrorMessage = "Action failed."
        }
        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-ResetAllSettings
