function Set-Magewell-NDIDevice-RNDISConfiguration
{
    <#
    .SYNOPSIS
     Use the interface to set the RNDIS address.

    .DESCRIPTION
     Use the interface to set the RNDIS address.

    .PARAMETER USBIPAddress
     Incicates the IP address as 192.168.xxx.1.

    .PARAMETER Name
     Set the name of the device.
     
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
        [Alias("addr")]
        [string]$USBIPAddress,

        [Parameter(Mandatory = $true)]
        [string]$Name,

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
Export-ModuleMember -Function Set-Magewell-NDIDevice-RNDISConfiguration
