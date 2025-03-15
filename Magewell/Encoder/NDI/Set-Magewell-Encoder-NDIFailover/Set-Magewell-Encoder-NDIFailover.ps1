function Invoke-Magewell-Encoder-NDIFailover
{
    <#
    .SYNOPSIS
     Enables failover and configures failover options for NDI.

    .DESCRIPTION
     Enables failover and configures failover options for NDI.

    .PARAMETER EnableFailOver
     Indicates whether failover is enabled. If yes, when the source video fails, the backup device begins to provide a service, and it shows true; otherwise, it is false.

    .PARAMETER  FailOverNDIName
     Indicates the backup NDI channel name.

    .PARAMETER  FailOverIPAddress
     Indicates the IP Address of the backup NDI channel.     

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
     Invoke-Magewell-Encoder-NDIFailover -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString) -EnableFailOver

     Invoke-Magewell-Encoder-NDIFailover -IPAddress "192.168.66.1" -Session $mySession -EnableFailOver

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]$EnableFailOver,

        [Parameter(Mandatory = $true)]
        [string]$FailOverNDIName,

        [Parameter(Mandatory = $true)]
        [string]$FailOverIPAddress,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config"

        if ($PSBoundParameters.ContainsKey("EnableFailOver"))
        {
            $url = $url + "&enable-fail-over=" + $EnableFailOver
        }

        if ($PSBoundParameters.ContainsKey("FailOverNDIName"))
        {
            $url = $url + "&fail-over-ndi-name=" + $FailOverNDIName
        }

        if ($PSBoundParameters.ContainsKey("FailOverIPAddress"))
        {
            $url = $url + "&fail-over-ip-addr=" + $FailOverIPAddress
        }

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to configure NDI fail-over settings."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-Encoder-NDIFailover
