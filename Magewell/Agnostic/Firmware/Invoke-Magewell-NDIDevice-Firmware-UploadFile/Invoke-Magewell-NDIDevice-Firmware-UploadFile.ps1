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

    .OUTPUTS
      Returns a WebRequestSession.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-Firmware-UploadFile -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [String]$Path,

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

        $url = "http://" + $IPAddress + "/mwapi?method=upload-update-file"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attepmting to upload firmware file to upgrade firmware."
            SuccessMessage = "Action taken successfully, check results for any issues."
            ErrorMessage = "Action failed."
        }

        if ($Path)
        {
            $argumentList.add("Path", $Path)
        }

        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-Firmware-UploadFile
