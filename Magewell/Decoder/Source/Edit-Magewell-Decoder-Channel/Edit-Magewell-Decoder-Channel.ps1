function Edit-Magewell-Decoder-Channel
{
    <#
    .SYNOPSIS
     Use the interface to modify the preset source information.

    .DESCRIPTION
     Use the interface to modify the preset source information.

    .PARAMETER Name
     Indicates the source name which should be identical.
     The name ranges from 1 to 120 english characters.

    .PARAMETER NewName
     Indicates the selected source name.

    .PARAMETER URL
     Indicates the source URL.

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
     Edit-Magewell-Decoder-Channel -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Name "xxx" -URL "XXX"

     Edit-Magewell-Decoder-Channel -IPAddress "192.168.66.1" -Session $mySession -Name "xxx" -URL "XXX"


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

        [Parameter(Mandatory = $true)]
        [string]$NewName,

        [Parameter(Mandatory = $true)]
        [string]$URL,

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
        [NDIDeviceModels] $deviceModel = Get-Magewell-NDIDevice-Model @modelArguments

        if ($deviceModel -eq [NDIDeviceModels]::Encoder)
        {
            Write-Warning "Device is a Magewell Encoder..."
            Throw "Device is an Encoder, cmdlet is meant for Decoders only."
        }
        
        Write-Verbose "Magewell Decoder Detected..."

        $url = "http://" + $IPAddress + "/mwapi?method=modify-channel&name=" + $Name + `
            "&new-name=" + $NewName + "&url=" + $URL
    
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
Export-ModuleMember -Function Edit-Magewell-Decoder-Channel
