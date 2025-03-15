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

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     NONE

    .EXAMPLE
      Set-Magewell-NDIDevice-RNDISConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Name "TV Decoder" -USBIPAddress "192.168.1.10"

      Set-Magewell-NDIDevice-RNDISConfiguration -IPAddress "192.168.66.1" -Session $mySession -Name "TV Decoder" -USBIPAddress "192.168.1.10"


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
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to take specified action."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-NDIDevice-RNDISConfiguration
