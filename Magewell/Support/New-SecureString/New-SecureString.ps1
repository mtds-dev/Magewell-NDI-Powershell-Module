function New-SecureString
{ 
    <#
      .SYNOPSIS
        Creates a new secure string

      .DESCRIPTION
        Creates a new secure string

      .EXAMPLE
        New-SecureString

      .LINK
        NONE

      .NOTES
        NONE
     #>
    [CmdletBinding()]
    param
    (
    )
    
    process
    {
        return Read-Host "Enter your Password" -AsSecureString
    }

}
Export-ModuleMember -Function New-SecureString
