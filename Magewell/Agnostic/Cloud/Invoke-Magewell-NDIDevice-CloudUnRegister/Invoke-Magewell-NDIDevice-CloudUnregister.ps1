function Invoke-Magewell-NDIDevice-CloudUnregister
{
    <#
    .SYNOPSIS
     Use the interface to release your device from a Magewell Cloud.

    .DESCRIPTION
     Use the interface to release your device from a Magewell Cloud.

    .PARAMETER  ID
     Cloud ID. Options are 0 and 1.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .OUTPUTS
      Returns a WebRequestSession.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-CloudUnregister -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$ID, 

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


        $url = "http://" + $IPAddress + "/cloud-api?method=cloud-unreg-ex&id=1"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Reaching out to the Cloud API... attempting to unregister device form cloud."
            SuccessMessage = "Cloud API connected, check results for status."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-CloudUnregister
