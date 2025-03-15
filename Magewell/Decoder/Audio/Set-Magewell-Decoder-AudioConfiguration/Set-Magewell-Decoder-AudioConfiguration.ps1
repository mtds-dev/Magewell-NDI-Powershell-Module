function Set-Magewell-Decoder-AudioConfiguration
{
    <#
    .SYNOPSIS
     Use the interface to modify audio settings.

    .DESCRIPTION
     Use the interface to modify audio settings.

    .PARAMETER Gain
     Adjust the gain from -100.00dB to 20.00dB as needed.

    .PARAMETER SampleRate
     Set the sample rate for your work, including 32000, 44100, 48000, 88200, 96000.

    .PARAMETER Channels
     Choose the proper audio channels for your work, including Follow input, 2 Channels, 4 Channels, 8 Channels. Then you can set the mapping relationship between the output and source channels.
     0 indicates to follow input.
     When the channels is set to 2, the selected audio channels map for output channel 1/2.
     When the channels is set to 4, the selected audio channels map for output channel 1/2 & 3/4.
     When the channels is set to 8, the selected audio channels map for output channel 1/2, 3/4, 5/6, 7/8.

    .PARAMETER ChannelZero
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelOne
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelTwo
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelThree
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelFour
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelFive
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelSix
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelSeven
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelEight
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelNine
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelTen
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelEleven
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelTwelve
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelThirteen
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelFourteen
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER ChannelFifteen
     Map the audio channels between the output and source channels when channels is not 0.
     For example, channels=2&ch0=4&ch1=5 indicates 2 channels are selected. Output channel1 maps the source channel5, and output channel2 maps the source channel6.

    .PARAMETER CheckPTS
     True indicates check the audio PTS is enabled, otherwise it is false.

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
      Set-Magewell-Decoder-AudioConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Gain 50

      Set-Magewell-Decoder-AudioConfiguration -IPAddress "192.168.66.1" -Session $mySession -Gain 50

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [ValidateRange(-100,20)]
        [Parameter(Mandatory = $false)]
        [int]$Gain,

        [ValidateSet('32000','44100','48000','88200','96000')]
        [Parameter(Mandatory = $false)]
        [string]$SampleRate,

        [ValidateSet('0','2','4','8')]
        [Parameter(Mandatory = $false)]
        [string]$Channels,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelZero,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelOne,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelTwo,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelThree,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelFour,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelFive,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelSix,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelSeven,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelEight,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelNine,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelTen,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelEleven,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelTwelve,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelThirteen,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelFourteen,

        [ValidateRange(0,15)]
        [Parameter(Mandatory = $false)]
        [string]$ChannelFifteen,

        [Parameter(Mandatory = $false)]
        [bool]$CheckPTS,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-audio-config"

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

        if ($Gain)
        {
            $url = $url + "&gain=" + $Gain
        }
        if ($SampleRate)
        {
            $url = $url + "&sample-rate=" + $SampleRate
        }
        if ($Channels)
        {
            $url = $url + "&channels=" + $Channels
        }
        if ($ChannelZero)
        {
            $url = $url + "&ch0=" + $ChannelZero
        }
        if ($ChannelOne)
        {
            $url = $url + "&ch1=" + $ChannelOne
        }
        if ($ChannelTwo)
        {
            $url = $url + "&ch2=" + $ChannelTwo
        }
        if ($ChannelThree)
        {
            $url = $url + "&ch3=" + $ChannelThree
        }
        if ($ChannelFour)
        {
            $url = $url + "&ch4=" + $ChannelFour
        }
        if ($ChannelFive)
        {
            $url = $url + "&ch5=" + $ChannelFive
        }
        if ($ChannelSix)
        {
            $url = $url + "&ch6=" + $ChannelSix
        }
        if ($ChannelSeven)
        {
            $url = $url + "&ch7=" + $ChannelSeven
        }
        if ($ChannelEight)
        {
            $url = $url + "&ch8=" + $ChannelEight
        }
        if ($ChannelNine)
        {
            $url = $url + "&ch9=" + $ChannelNine
        }
        if ($ChannelTen)
        {
            $url = $url + "&ch10=" + $ChannelTen
        }
        if ($ChannelEleven)
        {
            $url = $url + "&ch11=" + $ChannelElven
        }
        if ($ChannelTwelve)
        {
            $url = $url + "&ch12=" + $ChannelTwelve
        }
        if ($ChannelThirteen)
        {
            $url = $url + "&ch13=" + $ChannelThirteen
        }
        if ($ChannelFourteen)
        {
            $url = $url + "&ch14=" + $ChannelFourteen
        }
        if ($ChannelFifteen)
        {
            $url = $url + "&ch15=" + $ChannelFifteen
        }
        if ($CheckPTS)
        {
            $url = $url + "&check-pts=true" 
        } else
        {
            $url = $url + "&check-pts=false"
        }

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
Export-ModuleMember -Function Set-Magewell-Decoder-AudioConfiguration
