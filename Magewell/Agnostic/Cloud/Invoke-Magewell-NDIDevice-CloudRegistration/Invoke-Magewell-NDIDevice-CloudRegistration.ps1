function Invoke-Magewell-NDIDevice-CloudRegistration
{
    <#
    .SYNOPSIS
     Use the interface to register your device with Magewell Cloud. You can host your device to 2 cloud platforms simultaneously.
     
    .DESCRIPTION
     Use the interface to register your device with Magewell Cloud. You can host your device to 2 cloud platforms simultaneously.

    .PARAMETER  ID
     Cloud ID. Options are 0 and 1.

    .PARAMETER  CloudCode
     4-digit string invitation code given by the Cloud.

    .PARAMETER  CloudIPAddress
     IP address or domain of the Cloud.

    .PARAMETER  CloudHttpPort
     HTTP port of the Cloud server.

    .PARAMETER  CloudEnableHttps
     0: disable https
     1: enable https

    .PARAMETER  CloudHttpsPort
     HTTPS port of the Cloud server.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Returns JSON object.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-CloudRegistration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

      Invoke-Magewell-NDIDevice-CloudRegistration -IPAddress "192.168.66.1" -Session $mySession

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$ID, 

        [Parameter(Mandatory = $true)]
        [String]$CloudCode,

        [Parameter(Mandatory = $true)]
        [String]$CloudIPAddress,

        [Parameter(Mandatory = $true)]
        [String]$CloudHttpPort,

        [Parameter(Mandatory = $true)]
        [String]$CloudEnableHttps,

        [Parameter(Mandatory = $true)]
        [String]$CloudHttpsPort,

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
            Write-Host "Authentication failed, command will not be executed."
            return $null
        }

        $url = "http://" + $IPAddress + "/cloud-api?method=cloud-reg-ex&id=" + $ID + `
            "&cloud-code=" + $CloudCode + `
            "&cloud-ip-addr=" + $CloudIPAddress + `
            "&cloud-http-port=" + $CloudHttpPort + `
            "&cloud-enable-https=" + $CloudEnableHttps + `
            "&cloud-https-port=" + $CloudHttpsPort

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Reaching out to the cloud api... Attempting to Register with the Cloud."
            SuccessMessage = "Cloud API connected, check results for status."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-CloudRegistration
