function Set-Magewell-Encoder-NDIService
{
    <#
    .SYNOPSIS
     Use the interface to set NDI configurations.

    .DESCRIPTION
     Use the interface to set NDI configurations.

    .PARAMETER EnableNDI
     Indicates whether to enable NDI. If yes, it shows true; otherwise, it is false.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     Outputs to a JSON object.

    .EXAMPLE
     Set-Magewell-Encoder-NDIService -IPAddress "192.168.6.1" -UserName "Admin" -Password "myPassword" -EnableNDI $true

     Set-Magewell-Encoder-NDIService -IPAddress "192.168.6.1" -UserName "Admin" -Password "myPassword" -EnableNDI $false

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Bool]$EnableNDI,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config&enable="

        if ($EnableNDI)
        {
            $url = $url + "true"
        } else
        {
            $url = $url + "false"
        }

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to change the NDI service."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-NDIService
