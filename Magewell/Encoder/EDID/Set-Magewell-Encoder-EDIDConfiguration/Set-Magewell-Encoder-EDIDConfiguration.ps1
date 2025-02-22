function Set-Magewell-Encoder-EDIDConfiguration
{
    <#
    .SYNOPSIS
     Use the interface to modify EDID of input port.

    .DESCRIPTION
     Use the interface to modify EDID of input port.

    .PARAMETER SmartEDID
     Indicates whether to enable SmartEDID. If yes, it is true; otherwise, it is false.

    .PARAMETER KeepLast
     Indicates whether to use the latest loopthrough EDID. If yes, it is true; otherwise, it is false.

    .PARAMETER AddAudio
     Indicates whether to force the the source device to output audio. If yes, it is true; otherwise, it is false.

    .PARAMETER LimitPixelClock
     Indicates whether to lower pixel resolution to avoid the output producing a blank screen when the pixel resolution of the loop-through device is beyond the capability of the Pro Convert. If yes, it is true; otherwise, it is false.

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
     Outputs JSON object.

    .EXAMPLE
     Set-Magewell-Encoder-EDIDConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -SmartEDID $true

     Set-Magewell-Encoder-EDIDConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -KeepLast $true

     Set-Magewell-Encoder-EDIDConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -LimitPixelClock $true

     Set-Magewell-Encoder-EDIDConfiguration -IPAddress "192.168.66.1" -Session $mySession -LimitPixelClock $true

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Bool]$SmartEDID,

        [Parameter(Mandatory = $false)]
        [Bool]$KeepLast,

        [Parameter(Mandatory = $false)]
        [Bool]$AddAudio,

        [Parameter(Mandatory = $false)]
        [Bool]$LimitPixelClock,

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

        if ($deviceModel -eq [NDIDeviceModels]::Decoder)
        {
            Write-Warning "Device is a Magewell Decoder..."
            Throw "Device is a Decoder, cmdlet is meant for Encoders only."
        }

        Write-Verbose "Magewell Encoder Detected..." 
        $url = "http://" + $IPAddress + "/mwapi?method=set-edid-config"

        if ($PSBoundParameters.ContainsKey("SmartEDID"))
        {
            $url = $url + "&smart-edid=" + $SmartEDID
        }

        if ($PSBoundParameters.ContainsKey("KeepLast"))
        {
            $url = $url + "&keep-last=" + $KeepLast
        }
    
        if ($PSBoundParameters.ContainsKey("AddAudio"))
        {
            $url = $url + "&add-audio=" + $AddAudio
        }

        if ($PSBoundParameters.ContainsKey("LimitPixelClock"))
        {
            $url = $url + "&limit-pixel-clock=" + $LimitPixelClock
        }
    
        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to set EDID configuration on the device."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-EDIDConfiguration
