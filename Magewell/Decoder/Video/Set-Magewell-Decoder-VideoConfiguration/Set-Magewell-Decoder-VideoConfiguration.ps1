function Set-Magewell-Decoder-VideoConfiguration
{
    <#
    .SYNOPSIS
     Utility functions to either reboot, check online status, sync-time, or schedule auto-reboots.

    .DESCRIPTION
     Utility functions to either reboot, check online status, sync-time, or schedule auto-reboots.

    .PARAMETER ShowTitle
     True indicates to overlay the name and resolution of the video source on the output, otherwise it is false.

    .PARAMETER ShowTally
     True indicates to overlay the Tally light status of selected NDI stream on the output, otherwise it is false.

    .PARAMETER ShowVUMeter
     True indicates to overlay the VU meter, a volume bar, on the output, otherwise it is false.

    .PARAMETER VUMeterMode
     Specify the measurement of the volume, including none, dbu, dbvu, dbfs, if audio gain is set, the post-gain-dbu, post-gain-dbvu, and post-gain-dbfs will show the gain effect.
     
    .PARAMETER  ShowCenterCross
     True indicates to overlay a center cross on the output which determines the center position of the entire image, otherwise it is false.

    .PARAMETER  SafeAreaMode
     Specify the dimension of a rectangular to mark the most important part of the picture which can be seen by the majority presentation device, including none, 4:3, 80%, and square.

    .PARAMETER  IdentMode
     Set to show/hide the device name or ident text that overlays the output, including none, ident-text, device-name.

    .PARAMETER  IdentText
     Specify digital label overlaid on the output.
     The label text ranges from 1 to 32 characters which contains A to Z, a to z, 0 to 9, and special characters including spaces, dash(_), minus(-) and plus(+) sign.
     
    .PARAMETER  HFlip
     True indicates to set a mirror effect, otherwise it is false.

    .PARAMETER  VFlip
     True indicates to reverse the active image vertically, otherwise it is false.

    .PARAMETER  DeinterlaceMode
     Convert interlaced video into a progressive form using bob or weave method.
     
    .PARAMETER ARConvertMode 
     Specify the method to convert the aspect ratio of the decoded video. Options are windowbox, full and zoom.

    .PARAMETER AlphaDispMode
     Specify the background for the alpha channel display. Options are alpha-only, alpha-blend-white, alpha-blend-black, alpha-blend-checkerboard.

    .PARAMETER InAutoColorFMT 
     True indicates to auto-set color space, which means the color space will be BT.601 for SD and BT.709 for HD according to the source, otherwise it is false.
     
    .PARAMETER InColorFMT
     Specify the color space to bt.601 or bt.709. This parameter is only used when InAutoColoFMT is set to false otherwise it has no effect.

    .PARAMETER SwitchMode
     Specify the image to either black screen(blank) or the last picture of the previous video(keep-last) when the NDI source is changed.

    .PARAMETER FollowInputMode
     True indicates the output resolution keeps consistent with that of the input source, otherwise it is false. It only applies to NDI to AIO, NDI to HDMI and NDI to SDI.

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
      Set-Magewell-Decoder-VideoConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString) -ShowTitle

      Set-Magewell-Decoder-VideoConfiguration -IPAddress "192.168.66.1" -Session $mySession -ShowTitle

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ShowTitle')]
        [bool]$ShowTitle,

        [Parameter(Mandatory = $true, ParameterSetName = 'ShowTally')]
        [bool]$ShowTally,

        [Parameter(Mandatory = $true, ParameterSetName = 'ShowVUMeter')]
        [bool]$ShowVUMeter,

        [ValidateSet('none','dbu','dbvu','dbfs')]
        [Parameter(Mandatory = $true, ParameterSetName = 'VUMeterMode')]
        [string]$VUMeterMode,

        [Parameter(Mandatory = $true, ParameterSetName = 'ShowCenterCross')]
        [bool]$ShowCenterCross,

        [ValidateSet('none','4:3','80%','square')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SafeAreaMode')]
        [string]$SafeAreaMode,

        [ValidateSet('none','ident-text','device-name')]
        [Parameter(Mandatory = $true, ParameterSetName = 'IdentMode')]
        [string]$IdentMode,

        [Parameter(Mandatory = $true, ParameterSetName = '$IdentText')]
        [string]$IdentText,

        [Parameter(Mandatory = $true, ParameterSetName = 'HFlip')]
        [bool]$HFlip,

        [Parameter(Mandatory = $true, ParameterSetName = 'VFlip')]
        [bool]$VFlip,

        [ValidateSet('bob','weave')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeinterlaceMode')]
        [string]$DeinterlaceMode,

        [ValidateSet('windowbox','full','zoom')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ARConvertMode')]
        [string]$ARConvertMode,

        [ValidateSet('alpha-only','alpha-blend-white','alpha-blend-black','alpha-blend-checkerboard')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AlphaDispMode')]
        [string]$AlphaDispMode,

        [Parameter(Mandatory = $true, ParameterSetName = 'InAutoColorFMT')]
        [bool]$InAutoColorFMT,

        [ValidateSet('bt.601','bt.709')]
        [Parameter(Mandatory = $true, ParameterSetName = 'InColorFMT')]
        [string]$InColorFMT,

        [ValidateSet('blank','keep-last')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SwitchMode')]
        [string]$SwitchMode,

        [Parameter(Mandatory = $true, ParameterSetName = 'FollowInputMode')]
        [bool]$FollowInputMode,

        [Parameter(Mandatory = $false)]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false)]
        [Alias("user")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $true)]
        [Alias('pass')]
        [System.Security.SecureString]$Password,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-video-config&"
    
        switch ($PSCmdlet.ParameterSetName)
        {
            'ShowTitle'
            {
                $url = $url + "show-title="
                if ($ShowTitle)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'ShowTally'
            {
                $url = $url + "show-tally="
                if ($ShowTally)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'ShowVUMeter'
            {
                $url = $url + "show-vu-meter="
                if ($ShowVUMeter)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'VUMeterMode'
            {
                $url = $url + "vu-meter-mode=" + $VUMeterMode
                break                
            }
            'ShowCenterCross'
            {
                $url = $url + "show-center-cross="
                if ($ShowCenterCross)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'SafeAreaMode'
            {
                $url = $url + "safe-area-mode=" + $SafeAreaMode
                break
            }
            'IdentMode'
            {
                $url = $url + "ident-mode=" + $IdentMode
                break
            }
            'IdentText'
            {
                $url = $url + "ident-text=" + $IdentText
                break
            }
            'HFlip'
            {
                $url = $url + "h-flip="
                if ($HFlip)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'VFlip'
            {
                $url = $url + "v-flip="
                if ($VFlip)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'DeinterlaceMode'
            {
                $url = $url + "deinterlace-mode=" + $DeinterlaceMode
                break
            }
            'ARConvertMode'
            {
                $url = $url + "ar-convert-mode=" + $ARConvertMode
                break
            }
            'AlphaDispMode'
            {
                $url = $url + "alpha-disp-mode=" + $AlphaDispMode
                break
            }
            'InAutoColorFMT'
            {
                $url = $url + "in-auto-color-fmt="
                if ($InAutoColorFMT)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'InColorFMT'
            {
                $url = $url + "in-color-fmt=" + $InColorFMT
                break
            }
            'SwitchMode'
            {
                $url = $url + "switch-mode=" + $SwitchMode
                break
            }
            'FollowInputMode'
            {
                $url = $url + "follow-input-mode=" 
                if ($FollowInputMode)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
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
Export-ModuleMember -Function Set-Magewell-Decoder-VideoConfiguration
