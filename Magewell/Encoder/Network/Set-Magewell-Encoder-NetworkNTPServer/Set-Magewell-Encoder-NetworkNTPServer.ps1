function Set-Magewell-Encoder-NetworkNTPServer
{
    <#
    .SYNOPSIS
     Use the interface to configure NTP service, and only the Administrator has the right.

    .DESCRIPTION
     Use the interface to configure NTP service, and only the Administrator has the right.

    .PARAMETER NTPServer
     NTP server address

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Outputs to a JSON Object.

    .EXAMPLE
     Set-Magewell-Encoder-NetworkNTPServer -IPAddress "192.168.66.1" -UserName "Admin -Password $(New-SecureString) -NTPServer "162.159.200.1"

     Set-Magewell-Encoder-NetworkNTPServer -IPAddress "192.168.66.1" -Session $mySession -NTPServer "162.159.200.1"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$NTPServer,

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
            Write-Warning "Authentication failed, command will not be executed."
            return $null
        }

        $modelArguments = @{
            IPAddress = $IPAddress
            UserName = $UserName
            Password = $Password
        }
        [NDIDeviceModels] $deviceModel = Get-Magewell-NDIDevice-Model  @modelArguments 

        if ($deviceModel -eq [NDIDeviceModels]::Decoder)
        {
            Write-Warning "Device is a Magewell Decoder..."
            Throw "Device is a Decoder, cmdlet is meant for Encoders only."
        }

        Write-Host "Magewell Encoder Detected..." 

        $url = "http://" + $IPAddress + `
            "/mwapi?method=set-ntp-server&ntp-server=" + $NTPServer

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to configure NTP Server settings."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-NetworkNTPServer
