function Get-Magewell-NDIDevice-Firmware-State
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

    .PARAMETER  Session
      WebRequestSession 

    .OUTPUTS
     Returns JSON object.

    .EXAMPLE
      Get-Magewell-NDIDevice-Firmware-State -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

      Get-Magewell-NDIDevice-Firmware-State -IPAddress "192.168.66.1" -Session $mySessions

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
      
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias('Pass')]
        [String]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session')]
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session

    )

    process
    {

        if ($null -eq $Session)
        {
            $sessionArguments = @{
                IPAddress = $IPAddress
                UserName = $UserName
                Password = $Password
            }
            $Session = Invoke-Magewell-NDIDevice-Authentication @sessionArguments 
        }

        if ($null -eq $session)
        {
            Write-Host "Authentication failed, command will not be executed."
            return $null
        }

        $url = "http://" + $IPAddress + "/mwapi?method=get-update-state"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Checking on Firmware Status."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Get-Magewell-NDIDevice-Firmware-State
