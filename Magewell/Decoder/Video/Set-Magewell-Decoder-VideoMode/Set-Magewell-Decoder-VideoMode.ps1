function Set-Magewell-Decoder-VideoMode
{
    <#
    .SYNOPSIS
     Use the interface to set the video resolution to playback. The value must be listed in the result of get-supported-video-modes.

    .DESCRIPTION
     Use the interface to set the video resolution to playback. The value must be listed in the result of get-supported-video-modes.

    .PARAMETER Width
     Shows the width of video in pixels.

    .PARAMETER Height
     Shows the height of video in pixels.

    .PARAMETER Interlaced
     True indicates that convert the video into an interlaced signal, otherwise it is false.

    .PARAMETER FieldRate
     Shows the field rate of the decoded NDI video.

    .PARAMETER  AspectRatio
     Shows the aspect ratio of the decoded NDI stream.

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
      Set-Magewell-Decoder-VideoMode -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -AspectRatio "xxx"

      Set-Magewell-Decoder-VideoMode -IPAddress "192.168.66.1" -Session $mySession -AspectRatio "xxx"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Width,

        [Parameter(Mandatory = $true)]
        [string]$Height,

        [Parameter(Mandatory = $true)]
        [bool]$Interlaced,

        [Parameter(Mandatory = $true)]
        [string]$FieldRate,

        [Parameter(Mandatory = $true)]
        [string]$AspectRatio,

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
        [String]$Password,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-video-mode&width" + $Width + `
            "&height=" + $Height + `
            "&Interlaced=" + $Interlaced + `
            "&FieldRate=" + $FieldRate + `
            "&AspectRatio=" + $AspectRatio
    
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
Export-ModuleMember -Function Set-Magewell-Decoder-VideoMode
