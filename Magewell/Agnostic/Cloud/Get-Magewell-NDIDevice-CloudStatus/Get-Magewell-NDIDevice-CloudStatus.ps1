function Get-Magewell-NDIDevice-CloudStatus
{
    <#
    .SYNOPSIS
     Use the interface to obtain status of the Cloud platforms that your device has registered with.

    .DESCRIPTION
     Use the interface to obtain status of the Cloud platforms that your device has registered with.

    .PARAMETER  IPAddress
     IPAddress of the device

    .PARAMETER  UserName
     Username of the device

    .PARAMETER  Password
     Password of the device

    .OUTPUTS
     Returns a JSON object.

    .EXAMPLE
      Get-Magewell-NDIDevice-CloudStatus -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

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
        [Alias('pass')]
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


        $url = "http://" + $IPAddress + "/cloud-api?method=cloud-status&version=1"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Reaching out to the Cloud API..."
            SuccessMessage = "Cloud API connected, check results for status."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Get-Magewell-NDIDevice-CloudStatus
