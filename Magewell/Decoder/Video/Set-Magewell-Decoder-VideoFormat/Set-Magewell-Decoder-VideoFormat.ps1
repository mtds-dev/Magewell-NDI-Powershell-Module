function Set-Magewell-Decoder-VideoFormat
{
    <#
    .SYNOPSIS
     Use the interface to set the video format

    .DESCRIPTION
     Use the interface to set the video format

    .PARAMETER ColorFormat
     Sets the color space, including rgb, yuv444, yuv422.

    .PARAMETER QuantRange
     Sets the quantization range, including limited and full. It only takes effect when color-format=rgb.

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
      Set-Magewell-Decoder-VideoFormat -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -ColorFormat rgb

      Set-Magewell-Decoder-VideoFormat -IPAddress "192.168.66.1" -Session $mySession -ColorFormat rgb

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [ValidateSet('rgb','yuv444','yuv422')]
        [Parameter(Mandatory = $true)]
        [string]$ColorFormat,

        [ValidateSet('limited','full')]
        [Parameter(Mandatory = $false)]
        [string]$QuantRange,

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

        $url = "http://" + $IPAddress + `
            "/mwapi?method=set-video-format&color-format=" + $ColorFormat

        if ($QuantRange -eq "rgb")
        {
            $url = $url + "&quant-range=" + $QuantRange
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
Export-ModuleMember -Function Set-Magewell-Decoder-VideoFormat
