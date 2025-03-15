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

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     NONE

    .EXAMPLE
      Set-Magewell-NDIDevice-NetworkConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString)

      Set-Magewell-NDIDevice-NetworkConfiguration -IPAddress "192.168.66.1" -Session $mySession

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("DeviceName")]
        [String]$Name,

        [Parameter(Mandatory = $true)]
        [String]$DHCP,

        [Parameter(Mandatory = $true)]
        [Alias("NewIP","addr")]
        [String]$NewIPAddress,

        [Parameter(Mandatory = $true)]
        [Alias("mask")]
        [String]$Netmask,

        [Parameter(Mandatory = $true)]
        [Alias("gw-addr")]
        [String]$DefaultGateway,

        [Parameter(Mandatory = $true)]
        [Alias("dns-addr","DNSAddress")]
        [String]$DNSServer,

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
