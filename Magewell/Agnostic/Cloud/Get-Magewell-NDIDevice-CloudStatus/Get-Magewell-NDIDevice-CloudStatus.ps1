function Get-Magewell-NDIDevice-CloudStatus
{
    <#
    .SYNOPSIS
     Use the interface to obtain status of the Cloud platforms your device has registered with.

    .DESCRIPTION
     Use the interface to obtain status of the Cloud platforms your device has registered with.

    .PARAMETER  IPAddress
     IPAddress of the device

    .PARAMETER  UserName
     Username of the device

    .PARAMETER  Password
     Password of the device

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Returns a JSON object.

    .EXAMPLE
      Get-Magewell-NDIDevice-CloudStatus -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

      Get-Magewell-NDIDevice-CloudStatus -IPAddress "192.168.66.1" -Session $mySession

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
        [Alias('pass')]
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


        $url = "http://" + $IPAddress + "/cloud-api?method=cloud-status&version=1"

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Reaching out to the Cloud API..."
            SuccessMessage = "Cloud API connected, check results for status."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Get-Magewell-NDIDevice-CloudStatus
