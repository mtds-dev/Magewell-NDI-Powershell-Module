function Invoke-Magewell-NDIDevice-Firmware-Update
{
    <#
    .SYNOPSIS
     Use the interface to update firmware. During the update process you can use the get-update-state interface to retrieve the current status.

    .DESCRIPTION
     Use the interface to update firmware. During the update process you can use the get-update-state interface to retrieve the current status.

    .PARAMETER  Mode
     Shows the update mode, such as manual indicates to update the device to a specified version manually.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .OUTPUTS
      Returns a JSON object. 

    .EXAMPLE
      Invoke-Magewell-NDIDevice-Firmware-Update -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [String]$Mode = "manual",

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

        $url = "http://" + $IPAddress + "/mwapi?method=update&mode=" + $Mode

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to upgrade firmware on the device."
            SuccessMessage = "Action taken successfully, check results."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-Firmware-Update
