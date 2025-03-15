function Invoke-Magewell-NDIDevice-Authentication
{
    <#
    .SYNOPSIS
     A cmdlet that handles authentication and returns a WebRequestSession.

    .DESCRIPTION
     A cmdlet that handles authentication and returns a WebRequestSession.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .OUTPUTS
      Returns a WebRequestSession.

    .EXAMPLE
      Invoke-Magewell-NDIDevice-Authentication -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword"

      $session = Invoke-Magewell-NDIDevice-Authentication -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" 

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
        [Alias('Pass')]
        [System.Security.SecureString]$Password
    )

    process
    {
        Write-Verbose "Checking the connection to the IP Address: $IPAddress"

        if ((Test-Connection $IPAddress -Count 2 -Quiet) -eq $false)
        {
            Write-Warning "Unable to communicate with the specified IP Address: $IPAddress"
            return $null
        }

        Write-Verbose "IP Address is reachable."

        #Null out the proxy otherwise http request will hit the proxy and bounce a no route can be found error.
        #Add check for greater than PS 5 and provide the -NoProxy parameter.
        [System.Net.HttpWebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy($null)

        $passHash = New-MD5Hash -String $(ConvertFrom-SecureString -SecureString $Password -AsPlainText)

        $urlLogin = "http://" + $IPAddress + "/mwapi?method=login&id=" + `
            $UserName + "&pass=" + $passHash

        Write-Verbose  "Connecting to: $urlLogin"

        $loginResults = Invoke-WebRequest -Method Get -Uri $urlLogin -SessionVariable session

        $result = ConvertFrom-Json -InputObject $loginResults

        if ($result.status -eq 0)
        {
            Write-Verbose "Authentication was successfull."
            return $session
        } else
        {
            Write-Warning "Authentication to the device failed: $result"
            return $null
        }
    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-Authentication
