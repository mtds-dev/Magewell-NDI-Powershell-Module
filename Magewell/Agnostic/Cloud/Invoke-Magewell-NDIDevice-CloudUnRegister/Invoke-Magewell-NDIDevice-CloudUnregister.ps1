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

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .EXAMPLE
      Invoke-Magewell-NDIDevice-CloudUnregister -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

      Invoke-Magewell-NDIDevice-CloudUnregister -IPAddress "192.168.66.1" -Session $mySession

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$ID, 

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


        $url = "http://" + $IPAddress + "/cloud-api?method=cloud-unreg-ex&id=1"

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Reaching out to the Cloud API... attempting to unregister device form cloud."
            SuccessMessage = "Cloud API connected, check results for status."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-CloudUnregister
