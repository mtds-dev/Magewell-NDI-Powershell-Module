function Set-Magewell-Encoder-VideoConfiguration
{
    <#
    .SYNOPSIS
     Utility functions to either reboot, check online status, sync-time, or schedule auto-reboots.

    .DESCRIPTION
     Utility functions to either reboot, check online status, sync-time, or schedule auto-reboots.

    .PARAMETER InAutoColorFMT
     Indicates whether to obtain the color space of input signal automatically. If yes, it shows true; otherwise, it is false.

    .PARAMETER InColorFMT
     Indicates the color space of input signal, including rgb, bt.601, bt.709. bt.2020.

    .PARAMETER InAutoQuantRange
     Indicates whether to obtain the quantization range of input signal automatically. If yes, it shows true; otherwise, it is false.

    .PARAMETER InQuantRange
     Indicates the quantization range of input signal, including full, limited.

    .PARAMETER Brightness
     Indicates the brightness of input signal. The value ranges from -100 to +100.

    .PARAMETER Contrast
     Indicates the contrast of input signal. The value ranges from 50 to 200.

    .PARAMETER Hue
     Indicates the hue of input signal. The value ranges from -90 to 90.

    .PARAMETER Saturation
     Indicates the saturation range of input signal. The value ranges from 0 to 200.

    .PARAMETER Deinterlace
     Indicates deinterlace options of the input signal, including none, top-field, bottom-field.

    .PARAMETER OutMirror
     Indicates whether to horizontally flip the output signal.If yes, it shows true; otherwise, it is false.

    .PARAMETER OutCX
     Indicates the width of output resolution, the value is integer and multiple of 4.

    .PARAMETER OutCY 
     Indicates the height of output resolution, the value is integer and multiple of 2.

    .PARAMETER OutRawResolution
     Indicates whether the resolution of output follows that of input. If yes, it shows true; otherwise, it is false.

    .PARAMETER OutFRConvertion 
     Indicates the output frame rate, including raw，half, one-third, quarter.

    .PARAMETER OutAutoAspect
     Indicates whether to obtain the aspect ratio of output signal automatically. If yes, it shows true; otherwise, it is false.
     
    .PARAMETER OutAspectX
     Indicates the width of the output aspect ratio.

    .PARAMETER OutAspectY
     True indicates the output resolution keeps consistent with that of the input source, otherwise it is false. It only applies to NDI to AIO, NDI to HDMI and NDI to SDI.

    .PARAMETER BitRateRatio
     Indicates the bitrate ratio. The value ranges from 50 to 200, and the default value is 100.

    .PARAMETER OutAutoColorFMT
     Indicates whether to obtain the color space of output signal automatically. If yes, it shows true; otherwise, it is false.

    .PARAMETER OutColorFMT
     Indicates the color space of output signal, including bt.601, bt.709, bt.2020.

    .PARAMETER OutAutoSatRange
     Indicates whether to obtain the saturation range of output signal automatically. If yes, it shows true; otherwise, it is false.
        
    .PARAMETER OutAutoSatRange
     Indicates whether to obtain the saturation range of output signal automatically. If yes, it shows true; otherwise, it is false. 

    .PARAMETER OutSatRange
     Indicates the saturation range of output signal, including full, limited, extended.

    .PARAMETER OutAutoQuantRange
     Indicates whether to obtain the quantizations range of output signal automatically. If yes, it shows true; otherwise, it is false.

    .PARAMETER OutQuantRange
     Indicates the quantizations range of output signal, including full, limited.

    .PARAMETER LowResFullFR
     Indicates the Full frame rate for low bandwidth. If yes, it shows true; otherwise, it is false.

    .OUTPUTS
     Ouputs to JSON Object.

    .EXAMPLE
     Set-Magewell-Encoder-VideoConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Hue 50

     Set-Magewell-Encoder-VideoConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Brightness 100

     Set-Magewell-Encoder-VideoConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -InAutoColorFMT $true

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'InAutoColorFMT')]
        [Bool]$InAutoColorFMT,

        [ValidateSet('rgb','bt.601','bt.709','bt.2020')]
        [Parameter(Mandatory = $true, ParameterSetName = 'InColorFMT')]
        [String]$InColorFMT,

        [Parameter(Mandatory = $true, ParameterSetName = 'InAutoQuantRange')]
        [Bool]$InAutoQuantRange,

        [ValidateSet('full','limited')]
        [Parameter(Mandatory = $true, ParameterSetName = 'InQuantRange')]
        [String]$InQuantRange,

        [ValidateRange(-100, 100)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Brightness')]
        [Int]$Brightness,

        [ValidateRange(50,200)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Contrast')]
        [Int]$Contrast,

        [ValidateRange(-90,90)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Hue')]
        [Int]$Hue,

        [ValidateRange(0,200)]
        [Parameter(Mandatory = $true, ParameterSetName = '$Saturation')]
        [Int]$Saturation,

        [ValidateSet('none','top-field','bottom-field')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Deinterlace')]
        [String]$Deinterlace,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutMirror')]
        [Bool]$OutMirror,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutCX')]
        [int]$OutCX,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutCY')]
        [int]$OutCY,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutRawResolution')]
        [Bool]$OutRawResolution,

        [ValidateSet('raw','half','one-third','quarter')]
        [Parameter(Mandatory = $true, ParameterSetName = 'OutFRConvertion')]
        [String]$OutFRConvertion,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutAutoAspect')]
        [Bool]$OutAutoAspect,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutAspectX')]
        [Int]$OutAspectX,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutAspectY')]
        [Int]$OutAspectY,

        [ValidateRange(50,200)]
        [Parameter(Mandatory = $true, ParameterSetName = 'BitRateRatio')]
        [Int]$BitRateRatio,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutAutoColorFMT')]
        [Bool]$OutAutoColorFMT,

        [ValidateSet('bt.601','bt.709','bt.2020')]
        [Parameter(Mandatory = $true, ParameterSetName = 'OutColorFMT')]
        [String]$OutColorFMT,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutAutoSatRange')]
        [Bool]$OutAutoSatRange,

        [ValidateSet('full','limited','extended')]
        [Parameter(Mandatory = $true, ParameterSetName = 'OutSatRange')]
        [String]$OutSatRange,

        [Parameter(Mandatory = $true, ParameterSetName = 'OutAutoQuantRange')]
        [Bool]$OutAutoQuantRange,

        [ValidateSet('full','limited')]
        [Parameter(Mandatory = $true, ParameterSetName = 'OutQuantRange')]
        [String]$OutQuantRange,

        [Parameter(Mandatory = $true, ParameterSetName = 'LowResFullFR')]
        [Bool]$LowResFullFR,

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
            Write-Warniong "Authentication failed, command will not be executed."
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

        Write-Verbose "Magewell Encoder Detected..." 

        $url = "http://" + $IPAddress + "/mwapi?method=set-video-conf&"
    
        switch ($PSCmdlet.ParameterSetName)
        {
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
            'InAutoQuantRange'
            {
                $url = $url + "in-auto-quant-range="
                if ($InAutoQuantRange)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'InQuantRange'
            {
                $url = $url + "in-quant-range=" + $InQuantRange
                break                
            }
            'Brightness'
            {
                $url = $url + "brightness=" + $Brightness
                break
            }
            'Contrast'
            {
                $url = $url + "contrast=" + $Contrast
                break
            }
            'Hue'
            {
                $url = $url + "hue=" + $Hue
                break
            }
            'Saturation'
            {
                $url = $url + "saturation=" + $Saturation
                break
            }
            'Deinterlace'
            {
                $url = $url + "deinterlace=" + $Deinterlace
                break
            }
            'OutMirror'
            {
                $url = $url + "out-mirror="
                if ($OutMirror)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'OutCX'
            {
                $url = $url + "out-cx=" + $OutCX
                break
            }
            'OutCY'
            {
                $url = $url + "out-cy=" + $OutCY
                break
            }
            'OutRawResolution'
            {
                $url = $url + "out-raw-resolution="
                if ($OutRawResolution)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'OutFRConvertion'
            {
                $url = $url + "out-fr-convertion=" + $OutFRConvertion
                break
            }
            'OutAutoAspect'
            {
                $url = $url + "out-auto-aspect="
                if ($OutAutoAspect)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'OutAspectX'
            {
                $url = $url + "out-aspect-x=" + $OutAspectX
                break
            }
            'OutAspectY'
            {
                $url = $url + "out-aspect-y=" + $OutAspectY
                break
            }
            'AlphaDispMode'
            {
                $url = $url + "alpha-disp-mode=" + $AlphaDispMode
                break
            }
            'BitRateRatio'
            {
                $url = $url + "bit-rate-ratio=" + $BitRateRatio
                break
            }
            'OutAutoColorFMT'
            {
                $url = $url + "out-auto-color-fmt="
                if ($OutAutoColorFMT)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'OutColorFMT'
            {
                $url = $url + "out-color-fmt=" + $OutColorFMT
                break
            }
            'OutAutoSatRange'
            {
                $url = $url + "out-auto-sat-range="
                if ($OutAutoSatRange)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'OutSatRange'
            {
                $url = $url + "out-sat-range=" + $OutSatRange
                break
            }
            'OutAutoQuantRange'
            {
                $url = $url + "out-auto-quant-range="
                if ($OutAutoQuantRange)
                {
                    $url = $url + "true"
                } else
                {
                    $url = $url + "false"
                }
                break
            }
            'OutQuantRange'
            {
                $url = $url + "out-quant-range=" + $OutQuantRange
                break
            }
            'LowResFullFR'
            {
                $url = $url + "low-res-full-fr="
                if ($OutAutoQuantRange)
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
            Session = $session
            URL = $url
            BeginMessage = "Attempting to configure video configuration."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-VideoConfiguration
