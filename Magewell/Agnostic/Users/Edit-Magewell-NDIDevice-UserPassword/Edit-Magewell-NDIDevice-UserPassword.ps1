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
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     NONE

    .EXAMPLE
     NONE

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$NewPassword,

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

        $oldMD5Password = New-MD5Hash -String $Password
        $newMD5Password = New-MD5Hash -String $NewPassword
        $url = "http://" + $IPAddress + `
            "/mwapi?method=ch-password&pass=" + $oldMD5Password + `
            "&new-pass=" + $newMD5Password

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to modify user's password."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Edit-Magewell-NDIDevice-UserPassword
