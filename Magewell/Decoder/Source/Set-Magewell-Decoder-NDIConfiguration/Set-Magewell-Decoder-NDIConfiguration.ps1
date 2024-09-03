function Set-Magewell-Decoder-NDIConfiguration
{
    <#
    .SYNOPSIS
     Use the interface to set NDI.

    .DESCRIPTION
     Use the interface to set NDI.

    .PARAMETER EnableDiscovery
     Indicates the enable status of discovery server. Options are true and false.

    .PARAMETER DiscoveryServer
     Indicates server IP address. Multiple IP addresses should be separated with commas. It is mandatory when the value of enable-discovery is true.

    .PARAMETER SourceName
     Indicates the NDI source name which is retrieved using get-ndi-sources.

    .PARAMETER GroupName
     Indicates the group that the video source belongs to. By default it is public.

    .PARAMETER LowBandwidth
     True indicates the low bandwidth function is turned on, otherwise it is false.

    .PARAMETER EnableMCast
     True indicates the UDP (Multicast) is enabled, otherwise it is false.

    .PARAMETER EnableRUDP
     True indicates the RUDP (Unicast) is enabled, otherwise it is false.

    .PARAMETER EnableTCP
     True indicates the TCP (Multi-connection) is enabled, otherwise it is false.

    .PARAMETER EnableUDP
     True indicates the UDP (Unicast) is enabled, otherwise it is false.

    .PARAMETER IgnoreNDIHxVideoPTS
     True indicates ignore NDI video PTS is enabled, otherwise it is false.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     NONE

    .EXAMPLE
     NONE

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Discovery')]
        [bool]$EnableDiscovery,

        [Parameter(Mandatory = $false, ParameterSetName = 'Discovery')]
        [String]$DiscoveryServer,

        [Parameter(Mandatory = $true, ParameterSetName = 'SourceName')]
        [string]$SourceName,

        [Parameter(Mandatory = $true, ParameterSetName = 'GroupName')]
        [string]$GroupName,

        [Parameter(Mandatory = $true, ParameterSetName = 'LowBandwidth')]
        [bool]$LowBandwidth,

        [Parameter(Mandatory = $true, ParameterSetName = 'EnableMCast')]
        [bool]$EnableMCast,

        [Parameter(Mandatory = $true, ParameterSetName = 'EnableRUDP')]
        [bool]$EnableRUDP,

        [Parameter(Mandatory = $true, ParameterSetName = 'EnableTCP')]
        [bool]$EnableTCP,

        [Parameter(Mandatory = $true, ParameterSetName = 'EnableUDP')]
        [bool]$EnableUDP,

        [Parameter(Mandatory = $true, ParameterSetName = 'IgnoreNDIHxVideoPTS')]
        [bool]$IgnoreNDIHxVideoPTS,

        [Parameter(Mandatory = $false)]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false)]
        [Alias("user")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $true)]
        [Alias('pass')]
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

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config"

        switch ($PSCmdlet.ParameterSetName)
        {
            'EnableDiscovery'
            { 

                if ($EnableDiscovery)
                {
                    $url = $url + "&enable-discovery=true"
                } else
                {
                    $url = $url + "&enable-discovery=false"
                }
                if ($DiscoveryServer)
                {
                    $url = $url + "&discovery-server=" + $DiscoveryServer
                }
                break
            }
            'SourceName'
            {
                $url = $url + "&source-name=" + $SourceName
                break
            }
            'GroupName'
            {
                $url = $url + "&group-name=" + $GroupName
                break
            }
            'LowBandwidth'
            {
                if ($LowBandwidth)
                {
                    $url = $url + "&low-bandwidth=true"
                } else
                {
                    $url = $url + "&low-bandwidth=false"
                }
                break
            }
            'EnableMCast'
            {
                if ($EnableMCast)
                {
                    $url = $url + "&enable-mcast=true"
                } else
                {
                    $url = $url + "&enable-mcast=false"
                }
                break
            }
            'EnableRUDP'
            {
                if ($EnableRUDP)
                {
                    $url = $url + "&enable-rudp=true"
                } else
                {
                    $url = $url + "&enable-rudp=false"
                }
                break
            }
            'EnableTCP'
            {
                if ($EnableTCP)
                {
                    $url = $url + "&enable-tcp=true"
                } else
                {
                    $url = $url + "&enable-tcp=false"
                }
                break
            }
            'EnableUDP'
            {
                if ($EnableUDP)
                {
                    $url = $url + "&enable-udp=true"
                } else
                {
                    $url = $url + "&enable-udp=false"
                }
                break
            }
            'IgnoreNDIHxVideoPTS'
            {
                if ($IgnoreNDIHxVideoPTS)
                {
                    $url = $url + "&ignore-ndi-hx-video-pts=true"
                } else
                {
                    $url = $url + "&ignore-ndi-hx-video-pts=false"
                }
                break
            }
        }
    
        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to take specified action."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Decoder-NDIConfiguration
