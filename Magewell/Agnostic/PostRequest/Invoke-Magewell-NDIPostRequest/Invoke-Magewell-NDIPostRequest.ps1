function Invoke-Magewell-NDIPostRequest
{
    <#
    .SYNOPSIS
      A helper command that submits a web request to the Magewell device. 
      By default, responses will be converted from JSON however this can be 
      overriden by passing in HTMLResponse.

    .DESCRIPTION
      A helper command that submits the web request to the NDI device.

    .PARAMETER  URL
      This is the URL encoded string to provide as a POST request to the device.

    .PARAMETER  Path
     Path for file upload.

    .PARAMETER  HTMLResponse
      Override to expect HTML Response, instead of JSON.

    .PARAMETER  BeginMessage
      A general message that will be called at the start of the POST request.

    .PARAMETER  SuccessMessage
      A message that will be displayed if the POST request returns 0.

    .PARAMETER  ErrorMessage
      A message that will be displayed if the POST request returns an error.  
      The resulting error will be appending to the message as well.

    .EXAMPLE
      Invoke-Magewell-NDIPostRequest -Session $session
                              -URL "http://192.168.66.1/mwapi?method=set-ndi-config&enable=true&source-name=MySource"
                              -BeginMessage "Setting the Source..."
                              -SuccessMessage "Source Set."
                              -ErrorMessage "Unable to set the source.""

    .NOTES
     NONE
     #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Powershell.Commands.WebRequestSession] $Session,

        [Parameter(Mandatory = $true)]
        [String] $URL,

        [Parameter(Mandatory = $false)]
        [String] $Path,

        [Parameter(Mandatory = $false)]
        [Switch] $HTMLResponse,

        [Parameter(Mandatory = $true)]
        [String] $BeginMessage,

        [Parameter(Mandatory = $true)]
        [String] $SuccessMessage,

        [Parameter(Mandatory = $true)]
        [String] $ErrorMessage
    )

    process
    {
        
        Write-Verbose $BeginMessage
        Write-Verbose $URL

        $webRequestArguments = @{
            WebSession = $Session
            Uri = $URL
        }

        if ($Path)
        {
            $form = @{
                file = Get-Item -Path $Path
            }
            $webRequestArguments.Add('Form', $form)
            $webRequestArguments.Add('Method', "Post")
        }
        $rawResponse = Invoke-WebRequest @webRequestArguments

        $response = $null

        if ($PSBoundParameters.ContainsKey('HTMLResponse'))
        {
            #RETURN HTML RESPONSE
            $response = $rawResponse.content
            Write-Verbose $SuccessMessage
            return $response
        }

        $response = ConvertFrom-Json -InputObject $rawResponse.Content
        
        #RETURN JSON RESPONSE
        if ($response.status -eq 0 -or $response.result -eq 0)
        {
            Write-Verbose $SuccessMessage
            return $response
        } else
        {
            $warningMessage = $ErrorMessage + ": " + $response
            Write-Warning $warningMessage   
            return $response
        }
    }
}
Export-ModuleMember -Function Invoke-Magewell-NDIPostRequest
