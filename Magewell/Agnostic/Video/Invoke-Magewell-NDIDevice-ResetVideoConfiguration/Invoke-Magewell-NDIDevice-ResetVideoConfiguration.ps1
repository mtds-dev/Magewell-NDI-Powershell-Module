function Invoke-Magewell-NDIDevice-ResetVideoConfig
{
    <#
    .SYNOPSIS
     Use the interface to reset all video settings back to the default values.

    .DESCRIPTION
     Use the interface to reset all video settings back to the default values.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
     Password for the device

    .OUTPUTS
     NONE

    .EXAMPLE
     Invoke-Magewell-NDIDevice-ResetVideoConfigg -IPAddress 10.10.10.10 -UserName Admin -Password myPassword 

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

        $url = "http://" + $IPAddress + "/mwapi?method=reset-video-config"
        
        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to reset video configuration."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-ResetVideoConfig
