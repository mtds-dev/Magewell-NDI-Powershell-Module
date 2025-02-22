function Set-Magewell-Encoder-NDIAudioReferenceLevel
{
    <#
    .SYNOPSIS
     Changes NDI Audio level. SMPTE: 20 and EBU: 14

    .DESCRIPTION
     Changes NDI Audio level. SMPTE: 20 and EBU: 14

    .PARAMETER ReferenceLevel
     Indicates the audio reference level value. Options are
     SMPTE: 20
     EBU: 14

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
      Set-Magewell-Encoder-NDIAudioReferenceLevel -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -ReferenceLevel EBU

      Set-Magewell-Encoder-NDIAudioReferenceLevel -IPAddress "192.168.66.1" -Session $mySession -ReferenceLevel EBU

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [ValidateSet("SMPTE", "EBU")]
        [Parameter(Mandatory = $true)]
        [String]$ReferenceLevel,

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

        $url = "http://" + $IPAddress + `
            "/mwapi?method=set-ndi-config&reference-level="

        if ($ReferenceLevel -eq "SMPTE")
        {
            $url = $url + "20"
        } elseif ($ReferenceLevel -eq "EBU")
        {
            $url = $url + "14"
        }

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to change NDI audio reference levels."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-NDIAudioReferenceLevel
