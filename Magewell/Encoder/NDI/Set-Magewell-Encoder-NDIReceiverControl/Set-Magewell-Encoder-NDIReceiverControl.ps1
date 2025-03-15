function Invoke-Magewell-Encoder-NDIReceiverControl
{
    <#
    .SYNOPSIS
     Use this interface to enable/disable PTZ control or web control in NDI Studio Monitor.

    .DESCRIPTION
     Use this interface to enable/disable PTZ control or web control in NDI Studio Monitor.

    .PARAMETER EnablePTZControl
     Indicates whether you can control a connected PTZ camera through the NDI Studio Monitor. If yes, it shows true; otherwise, it is false.

    .PARAMETER  EnableWebControl
     Indicates whether you can open the Web UI by clicking the gear icon in the NDI Studio Monitor. If yes, it shows true; otherwise, it is false.

    .PARAMETER  IPAddress
     The ip address of the encoder.

    .PARAMETER  UserName
     The username to authenticate with.

    .PARAMETER  Password
     The password to authenticate with.

    .PARAMETER  Session
     Use a previously created WebRequestSession (Authentication session)
     Created using Invoke-Magewell-NDIDevice-Authentication. 

    .OUTPUTS
     Returns a JSON object.

    .EXAMPLE
      Invoke-Magewell-Encoder-NDIReceiverControl -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -EnablePTZControl

      Invoke-Magewell-Encoder-NDIReceiverControl -IPAddress "192.168.66.1" -Session $mySession -EnablePTZControl

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$EnablePTZControl,

        [Parameter(Mandatory = $false)]
        [Switch]$EnableWebControl,

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
            Write-Warning "Authentication failed, command will not be executed."
            return $null
        }


        $modelArguments = @{
            IPAddress = $IPAddress
            UserName = $UserName
            Password = $Password
        }
        [NDIDeviceModels] $deviceModel = Get-Magewell-NDIDevice-Model  @modelArguments 

        if ($deviceModel -eq [NDIDeviceModels]::Decoder)
        {
            Write-Warning "Device is a Magewell Decoder..."
            Throw "Device is a Decoder, cmdlet is meant for Encoders only."
        }

        Write-Verbose "Magewell Encoder Detected..." 

        $url = "http://" + $IPAddress + "/mwapi?method=set-ndi-config"

        if ($PSBoundParameters.ContainsKey("EnablePTZControl"))
        {
            $url = $url + "&enabel-ptz-control=" + $EnablePTZControl
        }

        if ($PSBoundParameters.ContainsKey("EnableWebControl"))
        {
            $url = $url + "&enable-web-control=" + $EnableWebControl
        }

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to configure NDI PTZ settings."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-Encoder-NDIReceiverControl
