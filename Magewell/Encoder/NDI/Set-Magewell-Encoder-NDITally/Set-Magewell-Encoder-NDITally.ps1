function Invoke-Magewell-Encoder-NDITally
{
    <#
    .SYNOPSIS
     Use the interface to enable the custom tally with administrative rights.

    .DESCRIPTION
     Use the interface to enable the custom tally with administrative rights.

    .PARAMETER EnableCustomLights
     Indicates whether to enable "User customized tally lights". If enabled, it is true; otherwise, it is false.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     Outputs to a JSON object.

    .EXAMPLE
     Invoke-Magewell-Encoder-NDITally -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -EnableCustomLights $true

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Switch]$EnableCustomLights,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-tally"

        if ($PSBoundParameters.ContainsKey("EnableCustomLights"))
        {
            $url = $url + "&ext-tally=" + $EnableCustomLights
        }

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to configure NDI tally."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-Encoder-NDITally
