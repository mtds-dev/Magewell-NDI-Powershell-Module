function Set-Magewell-Encoder-NDIDiscoveryServer
{
    <#
    .SYNOPSIS
     Use this interface to configure NDI's discovery server.

    .DESCRIPTION
     Use this interface to configure NDI's discovery server.

    .PARAMETER DisableDiscovery
     Disable Discovery server.
     
    .PARAMETER  DiscoveryServer
     Indicates the server IP address when discovery server is enabled. Multiple IP addresses should be separated with commas.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     Outputs JSON Object.

    .EXAMPLE
     NONE

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "DisableDiscovery")]
        [Switch]$DisableDiscovery,

        [Parameter(Mandatory = $true, ParameterSetName = "DiscoveryServer")]
        [String]$DiscoveryServer,

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

        Write-Verbose "Magewell Encoder Detected..." 

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config"

        if ($PSBoundParameters.ContainsKey("DisableDiscovery"))
        {
            $url = $url + "&enable-discovery=false"
        } elseif ($PSBoundParameters.ContainsKey("DiscoveryServer"))
        {
            $url = $url + "&enable-discovery=true&discovery-server=" + `
                $DiscoveryServer
        }

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to configure an NDI Discovery Server."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-NDIDiscoveryServer
