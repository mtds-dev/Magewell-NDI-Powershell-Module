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
        [Parameter(Mandatory = $true, ParameterSetName = 'SSDP')]
        [Alias("use-ssdp")]
        [string]$SSDP,

        [Parameter(Mandatory = $true, ParameterSetName = 'HTTPS')]
        [string]$HTTPS,

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


        $url = "http://" + $IPAddress + "/mwapi?method=set-net-access"

        switch ($PSCmdlet.ParameterSetName)
        {
            'SSDP'
            {
                $url = $url + "enable-ssdp=" + $SSDP
            }
            'HTTPS'
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
