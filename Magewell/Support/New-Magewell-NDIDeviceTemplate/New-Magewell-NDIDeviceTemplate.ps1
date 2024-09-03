function New-Magewell-NDIDeviceTemplate {
    <#
    .SYNOPSIS
     Create a NDI Device template (CSV) file in the desired location.

    .DESCRIPTION
     Create a NDI Device template (CSV) file in the desired location.

    .PARAMETER Path
     Enter the desired Path of the template.

    .INPUTS
      Path

    .EXAMPLE
      New-Magewell-NDIDeviceTemplate -Path "~\Desktop\ndidevices.csv"

    .LINK
     NONE

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (     
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    Copy-Item -Path $(Join-Path -Path $PSScriptRoot -ChildPath "NDIDeviceTemplate.csv") -Destination $Path -Force
}
Export-ModuleMember -Function New-Magewell-NDIDeviceTemplate
