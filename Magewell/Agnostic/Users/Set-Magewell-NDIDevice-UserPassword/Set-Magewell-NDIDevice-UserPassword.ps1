function Set-Magewell-NDIDevice-UserPassword
{
    <#
    .SYNOPSIS
     Use the interface to reset user password with administrative rights.

    .DESCRIPTION
     Use the interface to reset user password with administrative rights.

    .PARAMETER ID
     Indicates the username.

    .PARAMETER NewPassword
     The password you want to set for the user.

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
        [String]$ID,

        [Parameter(Mandatory = $true)]
        [String]$NewPassword,

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

        $newMD5Password = New-MD5Hash -String $NewPassword
        $url = "http://" + $IPAddress + "/mwapi?method=set-password&id=" + $ID + `
            "&pass=" + $newMD5Password

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to modify the user's account."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-NDIDevice-UserPassword
