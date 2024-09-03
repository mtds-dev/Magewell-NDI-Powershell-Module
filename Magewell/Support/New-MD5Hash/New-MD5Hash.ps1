function New-MD5Hash { 
    <#
      .SYNOPSIS
        Creates a new MD5 Hash

      .DESCRIPTION
        Creates a new MD5 Hash

      .PARAMETER  String
        String to be converted to a MD5Hash

      .EXAMPLE
        New-MD5Hash -String "test"

      .LINK
        NONE

      .NOTES
        NONE
     #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
            [String] $String
    )
    
    process {
      $bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
      $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create("MD5")
      $stringBuilder = New-Object System.Text.StringBuilder 
  
      $hashAlgorithm.ComputeHash($bytes) | 
      foreach-object { 
        $null = $stringBuilder.Append($_.ToString("x2")) 
      } 
  
      return $stringBuilder.ToString() 
    }

}
Export-ModuleMember -Function New-MD5Hash
