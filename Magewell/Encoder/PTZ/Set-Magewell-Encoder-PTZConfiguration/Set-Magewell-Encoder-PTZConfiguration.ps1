function Invoke-Magewell-Encoder-PTZConfiguration
{
    <#
    .SYNOPSIS
     Use the interface to set PTZ parameters.

    .DESCRIPTION
     Use the interface to set PTZ parameters.

    .PARAMETER Protocol
     Indicates the communication protocol that allows the camera and the converter to communicate to each other, including none. By default, it shows none. For now, only Sony VISCA Protocol is supported.

    .PARAMETER  Index
     Indicates the ID of the camera, which allows the controller to identify different PTZ cameras, especially when multiple cameras are connected. The value ranges from 1 to 7.

    .PARAMETER Baudrate
     Indicates the control data speed. For example, "9600 baud" means that the PTZ control port is capable of transferring a maximum of 9600 bits per second. If multiple cameras are connected, each camera should be set to the same value.
     Supported options including: 2400, 4800, 9600, 19200 and 38400.

    .PARAMETER  InvertPAN
     Indicates whether to reverse the pan-direction movement. If yes, it shows true; otherwise, it is false.

    .PARAMETER InvertTilt
     Indicates whether to reverse the tilt-direction movement. If yes, it shows true; otherwise, it is false.

    .PARAMETER  CameraIPAddress
     IP Address of the Camera.

    .PARAMETER CameraPort
     Port. The value ranges from 1 to 65535
     
    .PARAMETER  ViscaMsgHDR
     Indicates whether Visca UDP message header is used. If yes, it shows true; otherwise, it is false.

    .PARAMETER FocusNearLimit
     Focus near limit. The value ranges from 0 to 65535

    .PARAMETER  FocusFarLimit
     Focus far limit. The value ranges from 0 to 65535

    .PARAMETER PanLeftLimit
     Pan left limit. The value ranges from -32768 to 32767

    .PARAMETER  PanCenter
     Pan center. The value ranges from -32768 to 32767

    .PARAMETER PanRightLimit
     Pan right limit. The value ranges from -32768 to 32767

    .PARAMETER  TiltTopLimit
     Tilt top limit. The value ranges from -32768 to 32767

    .PARAMETER TiltCenter
     Tilt center. The value ranges from -32768 to 32767

    .PARAMETER  TiltBottomLimit
     Tilt bottom limit. The value ranges from -32768 to 32767

    .PARAMETER ZoomOutLimit
     Zoom out limit. The value ranges from 0 to 32767

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
     Outputs to JSON object.

    .EXAMPLE
     Set-Magewell-Encoder-PTZConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString) -Baudrate 38400

     Set-Magewell-Encoder-PTZConfiguration -IPAddress "192.168.66.1" -UserName "Admin" -Password $(New-SecureString) -TiltBottomLimit 500

     Set-Magewell-Encoder-PTZConfiguration -IPAddress "192.168.66.1" Session $mySession -TiltBottomLimit 500

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [String]$Protocol,

        [ValidateRange(1, 7)]
        [Parameter(Mandatory = $false)]
        [String]$Index,

        [ValidateSet("2400","4800","9600","19200","38400")]
        [Parameter(Mandatory = $false)]
        [String]$Baudrate,

        [Parameter(Mandatory = $false)]
        [Switch]$InvertPAN,

        [Parameter(Mandatory = $false)]
        [Switch]$InvertTilt,

        [Parameter(Mandatory = $false)]
        [Switch]$CameraIPAddress,

        [ValidateRange(1, 65535)]
        [Parameter(Mandatory = $false)]
        [String]$Port,

        [Parameter(Mandatory = $false)]
        [Switch]$ViscaMsgHDR,

        [ValidateRange(0, 65535)]
        [Parameter(Mandatory = $false)]
        [String]$FocusNearLimit,

        [ValidateRange(0, 65535)]
        [Parameter(Mandatory = $false)]
        [String]$FocusFarLimit,

        [ValidateRange(-32768, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$PanLeftLimit,

        [ValidateRange(-32768, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$PanCenter,

        [ValidateRange(-32768, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$PanRightLimit,

        [ValidateRange(-32768, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$TiltTopLimit,

        [ValidateRange(-32768, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$TiltCenter,

        [ValidateRange(-32768, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$TiltBottomLimit,

        [ValidateRange(0, 32767)]
        [Parameter(Mandatory = $false)]
        [String]$ZoomOutLimit,

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

        $url = "http://" + $IPAddress + "/mwapi?method=set-ptz-config"

        if ($PSBoundParameters.ContainsKey("Protocol"))
        {
            $url = $url + "&proto=" + $Protocol
        }

        if ($PSBoundParameters.ContainsKey("Index"))
        {
            $url = $url + "&index=" + $Index
        }

        if ($PSBoundParameters.ContainsKey("Baudrate"))
        {
            $url = $url + "&baudrate=" + $Baudrate
        }

        if ($PSBoundParameters.ContainsKey("InvertPAN"))
        {
            $url = $url + "&invert-pan=" + $InvertPAN
        }

        if ($PSBoundParameters.ContainsKey("InvertTilt"))
        {
            $url = $url + "&invert-tilt=" + $InvertTilt
        }

        if ($PSBoundParameters.ContainsKey("CameraIPAddress"))
        {
            $url = $url + "&ip-addr=" + $CameraIPAddress
        }

        if ($PSBoundParameters.ContainsKey("CameraPort"))
        {
            $url = $url + "&port=" + $CameraPort
        }

        if ($PSBoundParameters.ContainsKey("ViscaMsgHDR"))
        {
            $url = $url + "&visca-msg-hdr=" + $ViscaMsgHDR
        }

        if ($PSBoundParameters.ContainsKey("FocusNearLimit"))
        {
            $url = $url + "&focus-near-limit=" + $FocusNearLimit
        }

        if ($PSBoundParameters.ContainsKey("FocusFarLimit"))
        {
            $url = $url + "&focus-far-limit=" + $FocusFarLimit
        }

        if ($PSBoundParameters.ContainsKey("PanLeftLimit"))
        {
            $url = $url + "&pan-left-limit=" + $PanLeftLimit
        }

        if ($PSBoundParameters.ContainsKey("PanCenter"))
        {
            $url = $url + "&pan-center=" + $PanCenter
        }

        if ($PSBoundParameters.ContainsKey("PanRightLimit"))
        {
            $url = $url + "&pan-right-limit=" + $PanRightLimit
        }

        if ($PSBoundParameters.ContainsKey("TiltTopLimit"))
        {
            $url = $url + "&tilt-top-limit=" + $TiltTopLimit
        }

        if ($PSBoundParameters.ContainsKey("TiltCenter"))
        {
            $url = $url + "&tilt-center=" + $TiltCenter
        }

        if ($PSBoundParameters.ContainsKey("TiltBottomLimit"))
        {
            $url = $url + "&tilt-bottom-limit=" + $TiltBottomLimit
        }

        if ($PSBoundParameters.ContainsKey("ZoomOutLimit"))
        {
            $url = $url + "&zoom-out-limit=" + $ZoomOutLimit
        }

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to configure PTZ settings."
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Invoke-Magewell-Encoder-PTZConfiguration
