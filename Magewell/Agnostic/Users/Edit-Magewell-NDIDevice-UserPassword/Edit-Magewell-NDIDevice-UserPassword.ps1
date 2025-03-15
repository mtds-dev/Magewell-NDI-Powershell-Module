function Edit-Magewell-NDIDevice-UserPassword
{
    <#
    .SYNOPSIS
     Use the interface to modify password after logging in with old password. (Current user)

    .DESCRIPTION
     Use the interface to modify password after logging in with old password. (Current user)

    .PARAMETER NewPassword
     The new password you want to set for the user.

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
      Edit-Magewell-NDIDevice-UserPassword -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -NewPassword "myNewPassword"

      Edit-Magewell-NDIDevice-UserPassword -IPAddress "192.168.66.1" -Session $mySession -NewPassword "myNewPassword"


    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$NewPassword,

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

        $oldMD5Password = New-MD5Hash -String $Password
        $newMD5Password = New-MD5Hash -String $NewPassword
        $url = "http://" + $IPAddress + `
            "/mwapi?method=ch-password&pass=" + $oldMD5Password + `
            "&new-pass=" + $newMD5Password

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to modify user's password."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Edit-Magewell-NDIDevice-UserPassword
