function Set-Magewell-Encoder-NDIVendor
{
    <#
    .SYNOPSIS
     Use this interface to set the NDI Vendor Name and ID.

    .DESCRIPTION
     Use this interface to set the NDI Vendor Name and ID.

    .PARAMETER VendorName
     1 to 63 characters

    .PARAMETER  VendorID
     1 to 31 characters

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
     Outputs to JSON Object.

    .EXAMPLE
     Set-Magewell-Encoder-NDIVendor -IPAddress "192.168.66.1" -UserName "Admin" -Password "myPassword" -VendorName "vendorName" -VendorID "vendorID"

     Set-Magewell-Encoder-NDIVendor -IPAddress "192.168.66.1" -Session $mySession -VendorName "vendorName" -VendorID "vendorID"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [ValidatePattern('^(.{1.63})$')]
        [Parameter(Mandatory = $false)]
        [String]$VendorName,

        [ValidatePattern('^(.{1.31})$')]
        [Parameter(Mandatory = $false)]
        [String]$VendorID,

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
        [String]$Password,

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

        if ($PSBoundParameters.ContainsKey("VendorName"))
        {
            $url = $url + "&vendor-name=" + $VendorName
        }

        if ($PSBoundParameters.ContainsKey("VendorID"))
        {
            $url = $url + "&vendor-id=" + $VendorID
        }

        $argumentList = @{
            Session = $Session
            URL = $url
            BeginMessage = "Attempting to configure NDI Vendor Name"
            SuccessMessage = "Action taken successfully."
            ErrorMessage = "Action failed."
        }
        return Invoke-Magewell-NDIPostRequest @argumentList

    }
}
Export-ModuleMember -Function Set-Magewell-Encoder-NDIVendor
