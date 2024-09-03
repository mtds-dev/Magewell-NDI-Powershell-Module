function Invoke-Magewell-NDIDevice-SSLCertKey-Upload
{
    <#
    .SYNOPSIS
     Use the interface to upload the CA private key.

    .DESCRIPTION
     Use the interface to upload the CA private key.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .OUTPUTS
      Returns a WebRequestSession.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-SSLCertKey-Upload -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

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


        $url = "http://" + $IPAddress + "/mwapi?method=upload-ssl-cert-key"

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to upload SSL certificate."
            SuccessMessage = "Action taken successfully, check response."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-SSLCertKey-Upload
