$publicFolders = @("Magewell")
foreach ($publicFolder in $publicFolders) {
    $functionFolderPath = Join-Path -Path $PSScriptRoot -ChildPath $publicFolder
    
    if (Test-Path -Path $functionFolderPath) {
        $functions = Get-ChildItem -Path $functionFolderPath -Filter '*.ps1' -Recurse
        foreach ($function in $functions) {
            . $($function.FullName)
        }
    }

}
