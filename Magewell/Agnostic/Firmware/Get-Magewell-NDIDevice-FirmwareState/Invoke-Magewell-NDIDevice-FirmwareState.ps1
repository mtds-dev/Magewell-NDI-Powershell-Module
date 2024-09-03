function Invoke-Magewell-NDIDevice-FirmwareState
{
    <#
    .SYNOPSIS
     Use the interface to retrieve the current firmware information and update status with administrative rights.

    .DESCRIPTION
     Use the interface to retrieve the current firmware information and update status with administrative rights.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .OUTPUTS
     Returns JSON object.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-FirmwareState -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false)]
        [Alias("User")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $true)]
        [Alias('Pass')]
        [String]$Password
    )

    process
    {

        $sessionArguments = @{
            IPAddress = $IPAddress
            UserName = $UserName
            Password = $Password
        }
        $session = Invoke-Magewell-NDIDevice-Authentication @sessionArguments 

        if ($null -eq $session)
        {
            Write-Host "Authentication failed, command will not be executed."
            return $null
        }

        $url = "http://" + $IPAddress + "/mwapi?method=get-update-state"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to reset device."
            SuccessMessage = "Action taken successfully, reset may take up to two minutes, please do not turn off your device."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-FirmwareState
