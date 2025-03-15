function Invoke-Magewell-NDIDevice-Firmware-Upgrade
{
    <#
    .SYNOPSIS
     Use the interface to update firmware. During the update process you can use the get-update-state interface to retrieve the current status.

    .DESCRIPTION
     Use the interface to update firmware. During the update process you can use the get-update-state interface to retrieve the current status.

    .PARAMETER  Path
      Path to firmware file.

    .PARAMETER  IPAddress
      IPAddress of the device

    .PARAMETER  UserName
      Username of the device

    .PARAMETER  Password
      Password of the device

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
      Returns a JSON object. 

    .EXAMPLE
      Invoke-Magewell-NDIDevice-Firmware-Upgrade -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -Path ~/Downloads/pro_convert_hdmi_tx_rev_a_1_1_296.mwf

      Invoke-Magewell-NDIDevice-Firmware-Upgrade -IPAddress "192.168.66.1" -Session $mySession -Path ~/Downloads/pro_convert_hdmi_tx_rev_a_1_1_296.mwf

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $true, ParameterSetName = 'New-Session')]
        [String]$Path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Pass-Session')]
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("IP")]
        [String]$IPAddress = "192.168.66.1",

        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias("User")]
        [String]$UserName = "Admin",
      
        [Parameter(Mandatory = $false, ParameterSetName = 'New-Session')]
        [Alias('Pass')]
        [System.Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = 'Pass-Session')]
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session
    )

    process
    {
        if ($null -eq $Session)
        {
            $sessionArguments = @{
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

        $firmwareUploadArguments = @{
            IPAddress = $IPAddress
            Session = $Session
            Path = $Path
        }

        Write-Host @("Upgrading Firmware on: " + $IPAddress + " - Step 1 of 4 Uploading Firmware File")

        $firmwareUploadResults = Invoke-Magewell-NDIDevice-Firmware-UploadFile @firmwareUploadArguments
        if ($firmwareUploadResults -eq 39)
        {
            Write-Warning "Firmware type mismatch.  Check that your firmware file is correct for this device."
            return $null
        }


        $updateCommandResults = Invoke-Magewell-NDIDevice-Firmware-Update -Session $Session -IPAddress $IPAddress   
        if ($updateCommandResults -eq 39)
        {
            Write-Warning "Firmware type mismatch.  Check that your firmware file is correct for this device."
            return $null
        }

        $checkFirmwareStatus = Get-Magewell-NDIDevice-Firmware-State -Session $Session -IPAddress $IPAddress
        do
        {
            $checkFirmwareStatus = Get-Magewell-NDIDevice-Firmware-State -Session $Session -IPAddress $IPAddress
            if ($checkFirmwareStatus.'state' -eq "updating")
            {
                $updateMessage = @("Upgrading Firmware on: " + $IPAddress + " - Step " + $checkFirmwareStatus.'step-id' + " of " + $checkFirmwareStatus.'num-steps' + " " + $checkFirmwareStatus.'step-name' + " :" + $checkFirmwareStatus.'step-percent' + "%")
                Write-Host $updateMessage
                sleep(1)
            }
        } while ($checkFirmwareStatus.'state' -eq "updating")       
       
        sleep(1)
        Invoke-Magewell-NDIDevice-Utilities -Reboot -IPAddress $IPAddress -Password $Password -UserName $UserName
    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIDevice-Firmware-Upgrade
