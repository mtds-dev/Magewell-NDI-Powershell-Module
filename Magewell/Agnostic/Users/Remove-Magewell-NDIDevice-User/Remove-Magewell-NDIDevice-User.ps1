function Remove-Magewell-NDIDevice-User
{
    <#
    .SYNOPSIS
     Use the interface to delete general users with administrative rights.

    .DESCRIPTION
     Use the interface to delete general users with administrative rights.

    .PARAMETER ID
     User ID "UserName" to be deleted.

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
      Remove-Magewell-NDIDevice-User -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -ID 1

      Remove-Magewell-NDIDevice-User -IPAddress "192.168.66.1" -Session $mySession -ID 1

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ID,

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


        $url = "http://" + $IPAddress + "/mwapi?method=del-user&id=" + $ID

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to remove user."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Remove-Magewell-NDIDevice-User
