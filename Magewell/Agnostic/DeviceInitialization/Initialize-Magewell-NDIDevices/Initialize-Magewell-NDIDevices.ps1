function Initialize-Magewell-NDIDevices
{
    <#
    .SYNOPSIS
     Initialize more than one NDI Device using a CSV as a template.

    .DESCRIPTION
     Initialize more than one NDI Device using a CSV as a template.

    .PARAMETER Path
     Path to the CSV file.

    .INPUTS
     Path - to CSV File.

    .EXAMPLE        
     Initialize-Magewell-NDIDevices -Path "C:\NDIDevices.csv"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    process
    {
        Write-Verbose "Checking the given file exist."
        if (Test-Path -Path $Path)
        {
            Write-Verbose "The file existing, begining the import process..."
            $ndiDevices = Import-CSV -Path $Path

            if ($ndiDevices -eq 0 -or $ndiDevices -eq $null)
            {
                Write-Warning "No devices found in file."
                return $null
            } else
            {
                Write-Verbose "Devices Found: $ndiDevices.count"
            }

            foreach ($device in $ndiDevices)
            {
                $deviceArguments = @{
                    USBIPAddress = $device.USBIPAddress
                    DeviceName = $device.DeviceName
                    SourceName = $device.SourceName
                    GroupName = $device.GroupName
                    IPAddress = $device.IPAddress
                    SubnetMask = $device.SubnetMask
                    DefaultGateway = $device.DefaultGateway
                    DNSServer = $device.DNSServer
                    Password = $device.Password
                    NewPassword = $device.NewPassword
                }
                Initialize-Magewell-NDIDevice @deviceArguments
                pause
            }

        } else
        {
            Write-Warning "Unable to locate the file specified."
        }
    }

}
Export-ModuleMember -Function Initialize-Magewell-NDIDevices
