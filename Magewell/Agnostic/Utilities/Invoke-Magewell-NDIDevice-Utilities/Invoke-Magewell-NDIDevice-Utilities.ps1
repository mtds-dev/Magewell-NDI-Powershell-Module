function Invoke-Magewell-NDIDevice-Utilities
{
    <#
    .SYNOPSIS
     Utility functions to either reboot, check online status, sync-time, or schedule auto-reboots.

    .DESCRIPTION
     Utility functions to either reboot, check online status, sync-time, or schedule auto-reboots.

    .PARAMETER Ping
     To detect whether the device is accessible without login.

     This function is used to ensure that the device has restarted completely after firmware update, reset all settings or change IP address.

    .PARAMETER SyncClock
     Use the interface to synchronize clock with UTC with administrative right.

     To ensure that the system time is accurate, it is recommended to sync after administrative login.

    .PARAMETER SyncDate
     UTC date format: dd/MM/yyyy

    .PARAMETER SyncTime
     UTC time format: HH:mm:ss

    .PARAMETER  Reboot
     Reboot the device as administrator and log in again after rebooting.

     The reboot process may take a few minutes. You can use ping to determine whether the restart is finished.

    .PARAMETER  AutoReboot
     Use the interface to configure auto reboot.

    .PARAMETER  RebootEnabled
     True indicates the auto reboot function is enabled, otherwise it is false.

    .PARAMETER  RebootWeekFlags
     The sum of the masks for the selected days. The masks for Monday to Sunday are: 1, 2, 4, 8, 16, 32, 0. For example: When Monday and Wednesday are selected, week-flags=1+4=5

    .PARAMETER  RebootHour
     Time, 24-hour format. Value ranges from 0 to 23.

    .PARAMETER  RebootMinute
     Minute. Value ranges from 0 to 59.
    
    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .OUTPUTS
     NONE

    .EXAMPLE
     Invoke-Magewell-NDIDevice-Utilities -Ping -IPAddress 10.10.10.10 -UserName Admin -Password myPassword 

     Invoke-Magewell-NDIDevice-Utilities -Reboot -IPAddress 10.10.10.10 -UserName Admin -Password myPassword 

     Invoke-Magewell-NDIDevice-Utilities -SyncClock -SyncDate "31/12/2024" -SyncTime "23:59:59" -IPAddress 10.10.10.10 -UserName Admin -Password myPassword

     Invoke-Magewell-NDIDevice-Utilities -AutoReboot -RebootEnabled $false -IPAddress 10.10.10.10 -UserName Admin -Password myPassword

     Invoke-Magewell-NDIDevice-Utilities -AutoReboot -RebootEnabled $true -RebootWeekFlags 5 -RebootHour 23 -RebootMinute 0 -IPAddress 10.10.10.10 -UserName Admin -Password myPassword

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Ping')]
        [switch]$Ping,

        [Parameter(Mandatory = $true, ParameterSetName = 'SummaryInformation')]
        [switch]$SummaryInformation,

        [Parameter(Mandatory = $true, ParameterSetName = 'SyncClock')]
        [switch]$SyncClock,

        [Parameter(Mandatory = $true, ParameterSetName = 'SyncClock')]
        [string]$SyncDate,

        [Parameter(Mandatory = $true, ParameterSetName = 'SyncClock')]
        [string]$SyncTime,

        [Parameter(Mandatory = $true, ParameterSetName = 'Reboot')]
        [switch]$Reboot,

        [Parameter(Mandatory = $true, ParameterSetName = 'AutoReboot')]
        [switch]$AutoReboot,

        [Parameter(Mandatory = $true, ParameterSetName = 'AutoReboot')]
        [bool]$RebootEnabled,

        [ValidateRange(0,63)]
        [Parameter(Mandatory = $false, ParameterSetName = 'AutoReboot')]
        [int]$RebootWeekFlags,

        [ValidateRange(0,23)]
        [Parameter(Mandatory = $false, ParameterSetName = 'AutoReboot')]
        [int]$RebootHour,

        [ValidateRange(0,59)]
        [Parameter(Mandatory = $false, ParameterSetName = 'AutoReboot')]
        [int]$RebootMinute,

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

        $url = "http://" + $IPAddress + "/mwapi?method="
    
        switch ($PSCmdlet.ParameterSetName)
        {
            'Ping'
            {
                $url = $url + "ping"
                break
            }
            'SyncClock'
            {
                $url = $url + "sync-time&date=" + $SyncDate + "&time=" + $SyncTime
                break
            }
            'Reboot'
            {
                $url = $url + "reboot"
                break
            }
            'AutoReboot'
            {
                $url = $url + "set-auto-reboot&"
                if ($RebootEnabled)
                {
                    $url = $url + "enable=true&week-flags=" + $RebootWeekFlags + `
                        "&hour=" + $RebootHour + "&min=" + $RebootMinute
                } else
                {
                    $url = $url + "enable=false"
                }
            }
        }

        $argumentList = @{
            Session = $session
            URL = $url
            BeginMessage = "Attempting to take the specified action."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-Utilities
