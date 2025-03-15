function Invoke-Magewell-NDIDevice-Firmware-UploadFile
{
    <#
    .SYNOPSIS
     Use the interface to upload the .mwf file.

    .DESCRIPTION
     Use the interface to upload the .mwf file.

    .PARAMETER  Path
      Path to firmware file.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication.       WebRequestSession 

    .OUTPUTS
      Returns a WebRequestSession.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-Firmware-UploadFile -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString)

      Invoke-Magewell-NDIDevice-Firmware-UploadFile -IPAddress "192.168.66.1" -Session $mySession


    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $true, ParameterSetName = 'New-Session')]
        [String]$Path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("User")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias('Pass')]
        [System.Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session')]
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session)

    process
    {
        Write-Verbose $Session 
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

        $url = "http://" + $IPAddress + "/mwapi?method=upload-update-file"

        $argumentList = @{
            Session = $Session
            URL = $url
            Path = $Path
            BeginMessage = "Attepmting to upload firmware file to upgrade firmware."
            SuccessMessage = "Action taken successfully, check results for any issues."
            ErrorMessage = "Action failed."
        }

        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-Firmware-UploadFile
