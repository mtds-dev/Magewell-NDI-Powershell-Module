function Set-Magewell-NDIDevice-NetworkAccess
{
    <#
    .SYNOPSIS
     Use the interface to enable/disable SSDP and HTTPS.

    .DESCRIPTION
     Use the interface to enable/disable SSDP and HTTPS.     Use the interface to set the RNDIS address.

    .PARAMETER SSDP
     True indicates the SSDP service is enabled, otherwise it is false.

    .PARAMETER HTTPS
     True indicates that HTTPS is enabled, otherwise it is false

    .PARAMETER IPAddress
     The ip address of the device.

    .PARAMETER UserName
     The username to authenticate with.

    .PARAMETER Password
     The password to authenticate with.

    .PARAMETER Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Returns a JSON object.

    .EXAMPLE
      Set-Magewell-NDIDevice-NetworkAccess -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -HTTPS

      Set-Magewell-NDIDevice-NetworkAccess -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -SSDP

      Set-Magewell-NDIDevice-NetworkAccess -IPAddress "192.168.66.1" -Session $mySession -SSDP

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session-SSDP')]
        [Parameter(Mandatory = $true, ParameterSetName = 'New-Session-SSDP')]
        [Alias("use-ssdp")]
        [string]$SSDP,

        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session-HTTP')]
        [Parameter(Mandatory = $true, ParameterSetName = 'New-Session-HTTP')]
        [string]$HTTPS,

        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session-SSDP')]
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session-HTTP')]
        [Alias("User")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session-SSDP')]
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session-HTTP')]
        [Alias('Pass')]
        [System.Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session-SSDP')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session-HTTP')]
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


        $url = "http://" + $IPAddress + "/mwapi?method=set-net-access"

        switch ($PSCmdlet.ParameterSetName)
        {
            'Pass-Session-SSDP'
            {
                $url = $url + "enable-ssdp=" + $SSDP
            }
            'New-Session-SSDP'
            {
                $url = $url + "enable-ssdp=" + $SSDP
            }
            'Pass-Session-HTTP'
            {
                $url = $url + "enable-https=" + $HTTPS
            }
            'New-Session-HTTP'
            {
                $url = $url + "enable-https=" + $HTTPS
            }
        }

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
Export-ModuleMember -Function Set-Magewell-NDIDevice-NetworkAccess
