function Get-Magewell-NDIDevice-Model
{ 
    <#
    .SYNOPSIS
     Use this cmdlets to return the device model: ie., [NDIDeviceModels]::Encoder and [NDIDeviceModels]::Decoder.

    .DESCRIPTION
     Use this cmdlets to return the device model: ie., [NDIDeviceModels]::Encoder and [NDIDeviceModels]::Decoder.

    .PARAMETER IPAddress
     IPAddress of the device

    .PARAMETER UserName
     UserName to authenticate to the device.

    .PARAMETER Password
     Password used to authenticate to the device.

    .EXAMPLE
     Get-Magewell-NDIDevice-Model -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString)

    .LINK
     NONE
    .NOTES
     NONE
 #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false)]
        [Alias("User")]
        [String]$UserName = "Admin",

        [Parameter(Mandatory = $true)]
        [Alias("Pass")]
        [System.Security.SecureString]$Password
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

        $url = "http://" + $IPAddress + "/mwapi?method=get-summary-info" 
  
        $deviceModelCheckArguments = @{
            Session = $session 
            URL = $url 
            BeginMessage = "Checking Device Model..."
            SuccessMessage = "Retrieved Device Information Successfully"
            ErrorMessage = "Unable to connect to device."
        }
        $deviceCheck = Invoke-Magewell-NDIPOSTRequest @deviceModelCheckArguments

        if ($deviceCheck.device.model -eq "HDMI TX")
        {
            return [NDIDeviceModels]::Encoder
        }

        if ($deviceCheck.device.model -eq "NDI to HDMI")
        { 
            return [NDIDeviceModels]::Decoder
        }

    }
}
Export-ModuleMember -Function Get-Magewell-NDIDevice-Model
