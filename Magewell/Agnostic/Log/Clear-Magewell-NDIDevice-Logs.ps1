function Clear-Magewell-NDIDevice-Logs
{
    <#
    .SYNOPSIS
     Use the interface to clear all logs with administrative rights.

    .DESCRIPTION
     Use the interface to clear all logs with administrative rights.

    .PARAMETER  IPAddress
     The ip address of the device.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     NONE

    .EXAMPLE
     Clear-Magewell-NDIDevice-Logs -IPAddress "192.168.66.1" -UserName "Admin" -Passowrd "myPassword"

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
        [String]$Password,

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


        $url = "http://" + $IPAddress + "/mwapi?method=set-net-access"

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to clear logs on the device."
            SuccessMessage = "Action taken successfully, check response."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Clear-Magewell-NDIDevice-Logs
