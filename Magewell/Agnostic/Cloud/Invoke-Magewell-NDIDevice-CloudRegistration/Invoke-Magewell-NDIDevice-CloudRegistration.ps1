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

    .OUTPUTS
     Returns JSON object.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-CloudRegistration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

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
            Session = $session
            URL = $url
            BeginMessage = "Reaching out to the cloud api... Attempting to Register with the Cloud."
            SuccessMessage = "Cloud API connected, check results for status."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-CloudRegistration
