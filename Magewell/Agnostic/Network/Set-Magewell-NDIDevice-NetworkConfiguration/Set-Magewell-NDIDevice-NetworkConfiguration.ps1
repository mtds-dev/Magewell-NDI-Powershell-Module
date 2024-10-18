function Set-Magewell-NDIDevice-NetworkConfiguration
{
    <#
    .SYNOPSIS
     Use the interface to set Ethernet configurations.

    .DESCRIPTION
     Use the interface to set Ethernet configurations.

    .PARAMETER Name
     Device Name

    .PARAMETER DHCP
     True indicates that the decoder uses DHCP to retrieve IP address, otherwise it is false.

    .PARAMETER NewIPAddress
     Network IP Address for the Decoder.

    .PARAMETER Netmask
     Subnet mask address.

    .PARAMETER DefaultGateway
     Gateway address.

    .PARAMETER DNSServer 
     DNS Server IP Address

    .PARAMETER  IPAddress
     The ip address of the device.

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
        [Parameter(Mandatory = $true)]
        [Alias("DeviceName")]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$DHCP,

        [Parameter(Mandatory = $true)]
        [Alias("NewIP","addr")]
        [string]$NewIPAddress,

        [Parameter(Mandatory = $true)]
        [Alias("mask")]
        [string]$Netmask,

        [Parameter(Mandatory = $true)]
        [Alias("gw-addr")]
        [string]$DefaultGateway,

        [Parameter(Mandatory = $true)]
        [Alias("dns-addr","DNSAddress")]
        [string]$DNSServer,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-eth-config&name=" + $Name + `
            "&dhcp=" + $DHCP + `
            "&addr=" + $NewIPAddress + `
            "&mask=" + $Netmask + `
            "&gw-addr=" + $DefaultGateway + `
            "&dns-addr=" + $DNSAddress

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to take specified action."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-NDIDevice-NetworkConfiguration
