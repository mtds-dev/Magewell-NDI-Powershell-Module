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

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Returns a JSON object.

    .EXAMPLE
      Set-Magewell-NDIDevice-UserPassword -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -ID 1 -NewPassword "myNewPassword" 

      Set-Magewell-NDIDevice-UserPassword -IPAddress "192.168.66.1" -Session $mySession -ID 1 -NewPassword "myNewPassword"

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

        $newMD5Password = New-MD5Hash -String $NewPassword
        $url = "http://" + $IPAddress + "/mwapi?method=set-password&id=" + $ID + `
            "&pass=" + $newMD5Password

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to modify the user's account."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-NDIDevice-UserPassword
