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


        $url = "http://" + $IPAddress + "/mwapi?method=set-net-access"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to clear logs on the device."
            SuccessMessage = "Action taken successfully, check response."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Clear-Magewell-NDIDevice-Logs
