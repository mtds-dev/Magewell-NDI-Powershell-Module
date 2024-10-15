function Initialize-Magewell-NDIDevice
{
    <#
    .SYNOPSIS
     Configures a new Magwell Encoder\Decoder.

    .DESCRIPTION
     Configures a new Magwell Encoder\Decoder

    .PARAMETER  USBIPAddress
      Provide the IP Address of the device when connected via USB.  Default is 192.168.66.1.

    .PARAMETER  DeviceName
      Sets the DeviceName. This is usually the location of the device transmitting the video signal.

    .PARAMETER SourceName
      Sets the Source Name.  This is usually the name of the device transmitting the video signal. 

    .PARAMETER  GroupName
      Sets the NDI Group Name.  The default is usually public.

    .PARAMETER  IPAddress
      Sets the encoder's IP Address

    .PARAMETER  SubnetMask
      Sets the encoder's Subnet Mask.  Default is 255.255.252.0

    .PARAMETER  DefaultGateway
      Sets the encoder's Default Gateway.  

    .PARAMETER  DNSServer
      Sets the encoder's DNS Server.

    .PARAMETER  Password
      Default password to sign into the device.

    .PARAMETER  NewPassword
      Sets a new password for the device.
    
    .PARAMETER NTPServer 
      Sets the NTPServer settings for the device.
    
    .OUTPUTS
      The status of the update.

    .EXAMPLE
      Initialize-Magewell-NDIDevice -USBIPAddress "192.168.66.1" -DeviceName "RM 107" -SourceName "Creston Splitter" -GroupName "public" -IPAddress "10.4.128.29" -SubnetMask "255.255.255.0" -DefaultGateway "10.4.128.1" -DNSServer "10.1.8.141" -Password "Admin" -NewPassword "myPassword"

      Initialize-Magewell-NDIDevice -DeviceName "RM 107" -SourceName "Creston Splitter" -IPAddress "10.4.128.29" -SubnetMask "255.255.255.0" -DefaultGateway "10.4.128.1" -NewPassword "myPassword"
          #Only providing the bare minimum parameters and letting the defaults be applied
          #Parameters being overridden.
            #USBIPAddress: 192.168.66.1
            #GroupName: public
            #DNSServer: 10.1.8.141
            #Password: Admin

    .LINK
     NONE

    .NOTES
     NONE
     #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [String]$USBIPAddress = "192.168.66.1",
      
        [Parameter(Mandatory = $true)]
        [Alias("Location")]
        [String]$DeviceName,
      
        [Parameter(Mandatory = $true)]
        [String]$SourceName,

        [Parameter(Mandatory = $false)]
        [String]$GroupName = "public",

        [Parameter(Mandatory = $true)]
        [Alias("IP")]
        [String]$IPAddress,

        [Parameter(Mandatory = $true)]
        [Alias("Netmask")]
        [String]$SubnetMask,

        [Parameter(Mandatory = $true)]
        [Alias("DG")]
        [String]$DefaultGateway,

        [Parameter(Mandatory = $false)]
        [Alias("DNS")]
        [String]$DNSServer = "10.1.8.141",
        
        [Parameter(Mandatory = $false)]
        [String]$Password = "Admin",
      
        [Parameter(Mandatory = $true)]
        [String]$NewPassword,

        [Parameter(Mandatory = $false)]
        [String]$NTPServer = "10.1.1.10"

    )
    
    process 
    {
        $basicNetworkInformation = @{
            IPAddress = $USBIPAddress
            UserName = $UserName
            Password = $Password
        }

        [NDIDeviceModels]$deviceModel = Get-Magewell-NDIDevice-Model @basicNetworkInformation 

        if ([NDIDeviceModels]::Decoder -eq $deviceModel)
        {
            Set-Magewell-Decoder-NDIConfiguration @basicNetworkInformation -SourceName $SourceName
            Set-Magewell-Decoder-NDIConfiguration @basicNetworkInformation -GroupName $GroupName
            Set-Magewell-Decoder-VideoConfiguration @basicNetworkinformation -ShowVUMeter $false
            Set-Magewell-Decoder-AudioConfiguration @basicNetworkInformation -CheckPTS $false
            Set-Magewll-Decoder-Channel @basicNetworkInformation -Name "BLANK" -URL "BLANK"
        }

        if ([NDIDeviceModels]::Encoder -eq $deviceModel)
        {
            $ndiEncoderParameters = @{
                EnableMcast = $true
                EnableRUDP = $false
                EnableUDP = $false
                EnableTCP = $false
                McastIPAddress = $("239." + $IPAddress.Split(".")[2] + "." + $IPAddress.Split(".")[3] + ".0")
                McastMask = "255.255.255.0"
                McastTTL = 4
            }
            Set-Magewell-Encoder-NDITransitionMode @basicNetworkInformation @ndiEncoderParameters
            Set-Magewell-Encoder-NetworkNTPServer @basicNetworkInformation -NTPServer $NTPServer 
        }

        $networkParameters = @{
            Name = $DeviceName
            NewIPAddress = $IPAddress
            Netmask = $SubnetMask
            DefaultGateway = $DefaultGateway
            DNSServer = $DNSServer
            DHCP = "false"
        }
        Set-Magewell-NDIDevice-Network @basicNetworkInformation @networkParameters
        Set-Magewell-NDIDevice-UserPassword @basicNetworkInformation -ID $UserName -NewPassword $NewPassword
        Invoke-Magewell-NDIDevice-Utilities @basicNetworkInformation -Reboot
    }
}
Export-ModuleMember -Function Initialize-Magewell-NDIDevice
