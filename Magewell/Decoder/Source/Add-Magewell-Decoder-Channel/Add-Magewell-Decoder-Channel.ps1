function Add-Magewell-Decoder-Channel
{
    <#
    .SYNOPSIS
     Use the interface to add sources to preset list. Supported protocols are ntkndi, rtsp, http, rtmp, udp, srt, and rtp.
     Right now, use https://www.magewell.com/api-docs/pro-convert-decoder-api/source/add-channel.html to help build the urls
     Helper functions to follow eventually.

    .DESCRIPTION
     Use the interface to add sources to preset list. Supported protocols are ntkndi, rtsp, http, rtmp, udp, srt, and rtp.
     Right now, use https://www.magewell.com/api-docs/pro-convert-decoder-api/source/add-channel.html to help build the urls
     Helper functions to follow eventually.

    .PARAMETER Name
     Indicates the source name which should be identical.
     The source name ranges from 1 to 120 english characters.

    .PARAMETER URL
     Indicates the source URL. For more information on how to build a proper 
     URL, look at the Magewell API page.
     https://www.magewell.com/api-docs/pro-convert-decoder-api/source/add-channel.html

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
      Add-Magewell-Decoder-Channel -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Name "xxx" -URL "xxx"

      Add-Magewell-Decoder-Channel -IPAddress "192.168.66.1" -Session $mySession -Name "xxx" -Password "xxx"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("SourceName")]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$URL,

        [Parameter(Mandatory = $false, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("user")]
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
            Write-Warning "Authentication failed, command will not be executed."
            return $null
        }

        $modelArguments = @{
            IPAddress = $IPAddress
            UserName = $UserName
            Password = $Password
        }
        [NDIDeviceModels] $deviceModel = Get-Magewell-NDIDevice-Model  @modelArguments 

        if ($deviceModel -eq [NDIDeviceModels]::Encoder)
        {
            Write-Warning "Device is a Magewell Encoder..."
            Throw "Device is an Encoder, cmdlet is meant for Decoders only."
        }

        Write-Verbose "Magewell Decoder Detected..." 

        $url = "http://" + $IPAddress + "/mwapi?method=add-channel&name=" + $Name + `
            "&url=" + $URL
    
        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to take specified action."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Add-Magewell-Decoder-Channel
