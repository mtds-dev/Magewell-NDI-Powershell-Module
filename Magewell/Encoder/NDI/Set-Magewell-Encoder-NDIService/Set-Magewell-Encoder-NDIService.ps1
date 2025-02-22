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

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Outputs to a JSON object.

    .EXAMPLE
     Set-Magewell-Encoder-NDIService -IPAddress "192.168.6.1" -UserName "Admin" -Password "myPassword" -EnableNDI $true

     Set-Magewell-Encoder-NDIService -IPAddress "192.168.6.1" -UserName "Admin" -Password "myPassword" -EnableNDI $false

     Set-Magewell-Encoder-NDIService -IPAddress "192.168.6.1" -Session $mySession -EnableNDI $false

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Bool]$EnableNDI,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config&enable="

        if ($EnableNDI)
        {
            $url = $url + "true"
        } else
        {
            $url = $url + "false"
        }

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to change the NDI service."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-NDIService
