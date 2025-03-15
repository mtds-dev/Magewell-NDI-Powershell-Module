function Invoke-Magewell-Encoder-EDIDExport
{
    <#
    .SYNOPSIS
     Use the interface to export EDID configuration in a .bin file.

    .DESCRIPTION
     Use the interface to export EDID configuration in a .bin file.

    .PARAMETER Port
     Indicates the port type, including in, out.

    .PARAMETER FileName
     Indicates the BIN file name.
     
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
     Outputs JSON Object.

    .EXAMPLE
     Invoke-Magewell-Encoder-EDIDExport -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Port in -FileName "path/to/file.bin"

     Invoke-Magewell-Encoder-EDIDExport -IPAddress "192.168.66.1" -Session $mySession -Port in -FileName "path/to/file.bin"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [ValidateSet('in','out')]
        [Parameter(Mandatory = $true)]
        [Bool]$Port,

        [Parameter(Mandatory = $true)]
        [Bool]$FileName,

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

        if ($deviceModel -eq [NDIDeviceModels]::Decoder)
        {
            Write-Warning "Device is a Magewell Decoder..."
            Throw "Device is a Decoder, cmdlet is meant for Encoders only."
        }

        Write-Verbose "Magewell Encoder Detected..." 

        $url = "http://" + $IPAddress + "/mwapi?method=export-edid=" + $Port + `
            "&file-name=" + $FileName
    
        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to Export EDID configuration."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-Encoder-EDIDExport
