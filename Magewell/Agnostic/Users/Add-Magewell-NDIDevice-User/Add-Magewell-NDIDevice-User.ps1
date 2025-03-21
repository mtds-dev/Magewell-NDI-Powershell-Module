function Add-Magewell-NDIDevice-User
{
    <#
    .SYNOPSIS
     Use the interface to add general users with administrative rights.

    .DESCRIPTION
     Use the interface to add general users with administrative rights.

    .PARAMETER NewUserName
     Username of the new user..

    .PARAMETER NewUserPassword
     Password for the new user.

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
     NONE

    .EXAMPLE
     Add-Magewell-NDIDevice-User -IPAddress 10.10.10.1 -UserName "Admin" -Password $(New-SecureString) -NewUserName "myuser" -NewUserPassword "mypassword"

     Add-Magewell-NDIDevice-User -IPAddress 10.10.10.1 -Session $mySession -NewUserName "myuser" -NewUserPassword "mypassword"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("ID")]
        [string]$NewUserName,

        [Parameter(Mandatory = $true)]
        [string]$NewUserPassword,

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

        $newMD5Password = New-MD5Hash -String $NewUserPassword

        $url = "http://" + $IPAddress + "/mwapi?method=add-user&id=" + $NewUserName + `
            "&pass=" + $newMD5Password 

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to add a new user."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Add-Magewell-NDIDevice-User
