function Set-Magewell-Encoder-NDITransitionMode
{
    <#
    .SYNOPSIS
     Only one of enable-mcast, enable-rudp, enable-tcp and enable-udp can be true. When all are false, it means that the transmission mode is TCP (Uni-connection).

    .DESCRIPTION
     Only one of enable-mcast, enable-rudp, enable-tcp and enable-udp can be true. When all are false, it means that the transmission mode is TCP (Uni-connection).

    .PARAMETER EnableMCast
     Indicates whether the UDP (Multicast) is enabled. If yes, it shows true; otherwise, it is false.

    .PARAMETER  EnableRUDP
     Indicates whether the RUDP (Unicast) is enabled. If yes, it shows true; otherwise, it is false.

    .PARAMETER  EnableTCP
     Indicates whether the TCP (Multi-connection) is enabled. If yes, it shows true; otherwise, it is false.

    .PARAMETER  EnableUDP
     Indicates whether the UDP (Unicast) is enabled. If yes, it shows true; otherwise, it is false.

    .PARAMETER  McastIPAddress
     Indicates the multicast address.

    .PARAMETER McastMask  
     Indicates the subnet mask for multicast address.

    .PARAMETER  McastTTL
     Indicates the multicast time-to-live value, that is, the number of hops that a packet travels before being discarded in the local network. The value rages from 1 to 255.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     Outputs to a JSON object.

    .EXAMPLE
     Set-Magewell-Encoder-NDITransitionMode -IPAddress "192.168.66.1" -Username "Admin" -Password "myPassword" -EnableMCast $true

     Set-Magewell-Encoder-NDITransitionMode -IPAddress "192.168.66.1" -Username "Admin" -Password "myPassword" -EnableUDP $true

     Set-Magewell-Encoder-NDITransitionMode -IPAddress "192.168.66.1" -Username "Admin" -Password "myPassword" -EnableMCast $true

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "MCast")]
        [switch]$EnableMCast,

        [Parameter(Mandatory = $false)]
        [switch]$EnableRUDP,

        [Parameter(Mandatory = $false)]
        [switch]$EnableTCP,

        [Parameter(Mandatory = $false)]
        [switch]$EnableUDP,

        [Parameter(Mandatory = $false, ParameterSetName = "MCast")]
        [string]$McastIPAddress,

        [Parameter(Mandatory = $false, ParameterSetname = "MCast")]
        [string]$McastMask,

        [Parameter(Mandatory = $false, ParameterSetname = "MCast")]
        [string]$McastTTL,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config"

        if ($PSBoundParameters.ContainsKey("EnableMCast"))
        {
            $url = $url + "&enable-mcast=" + $EnableMCast
        }

        if ($PSBoundParameters.ContainsKey("EnableRUDP"))
        {
            $url = $url + "&enable-rudp=" + $EnableRUDP
        }

        if ($PSBoundParameters.ContainsKey("EnableTCP"))
        {
            $url = $url + "&enable-tcp=" + $EnableTCP
        }

        if ($PSBoundParameters.ContainsKey("EnableUDP"))
        {
            $url = $url + "&enable-udp=" + $EnableUDP
        }

        if ($PSBoundParameters.ContainsKey("McastIPAddress"))
        {
            $url = $url + "&mcast-addr=" + $McastIPAddress
        }

        if ($PSBoundParameters.ContainsKey("McastMask"))
        {
            $url = $url + "&mcast-mask=" + $McastMask
        }

        if ($PSBoundParameters.ContainsKey("McastTTL"))
        {
            $url = $url + "&mast-ttl=" + $McastTTL
        }

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to change NDI Network settings."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}    
Export-ModuleMember -Function Set-Magewell-Encoder-NDITransitionMode
