function Remove-Magewell-Decoder-Channel
{
    <#
    .SYNOPSIS
     Use the interface to delete preset source.

    .DESCRIPTION
     Use the interface to delete preset source.

    .PARAMETER Name
     Indicates the source name to be deleted.

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
     Remove-Magewell-Decoder-Channel -Name MyCameraFeed -IPAddress 10.10.10.10 -UserName Admin -Password myPassword

     Remove-Magewell-Decoder-Channel -Name MyCameraFeed -IPAddress 10.10.10.10 -Session $mySession

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("SourceName")]
        [string]$Name,

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

        $url = "http://" + $IPAddress + "/mwapi?method=del-channel&name=" + $Name 
    
        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to take specified action."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Remove-Magewell-Decoder-Channel
