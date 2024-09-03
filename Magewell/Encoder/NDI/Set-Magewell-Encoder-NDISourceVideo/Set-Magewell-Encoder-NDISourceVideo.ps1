function Invoke-Magewell-Encoder-NDISourceVideo
{
    <#
    .SYNOPSIS
     Use the interface to set NDI configurations.

    .DESCRIPTION
     Use the interface to set NDI configurations.

    .PARAMETER SourceName
     Indicates the NDI source name used for the converter. %board-id% and %serial-no% are the only supported variables.

    .PARAMETER  GroupName
     Indicates the group that the converter is multicasted to, separated by commas if there are multiple groups, including public,test, etc.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .OUTPUTS
     NONE

    .EXAMPLE
     NONE

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]$SourceName,

        [Parameter(Mandatory = $false)]
        [switch]$GroupName,

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

        if ($PSBoundParameters.ContainsKey("SourceName"))
        {
            $url = $url + "&source-name=" + $SourceName
        }

        if ($PSBoundParameters.ContainsKey("GroupName"))
        {
            $url = $url + "&group-name=" + $GroupName
        }

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to change NDI Source/Group."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-Encoder-NDISourceVideo
