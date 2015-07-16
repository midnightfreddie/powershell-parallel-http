filter Do-Cool-Parallel-Thingy-That-Takes-Uris-Via-Pipeline {
    # TODO: Cool-Parallel-ness
    begin {
        $MaxJobs = 2
        Write-Verbose "Begin!"
        $ScriptBlock = {
            $Parameters = @{
                Uri = $_
                Headers = @{ host = "midnightfreddie.com" } ##### NOTE! DELETE THIS LINE! I am using this due to how I'm testing against my servers, but you don't want this; it will probably mess you up
                UseBasicParsing = $true
            }
            try {
                $Result = Invoke-WebRequest @Parameters
            }
            catch [System.Net.WebException] {
                # Annoyingly, 404s throw an error and don't populate the variable. Unsure about other HTTP errors
                $Result = New-Object psobject -Property @{
                    StatusCode = "Request Error"
                    StatusDescription = $Error[0]
                }        }
            catch {
                throw
            }
            New-Object psobject -Property @{
                Uri = $_
                StatusCode = $Result.StatusCode
                StatusDescription = $Result.StatusDescription
                # Content = $Result.Content # maybe | ConvertFrom-Json ?
                # Headers = $Result.Headers
            }
        }
    }
    process {
        Invoke-Command -ScriptBlock $ScriptBlock -InputObject $_
    }
    end {
        Write-Verbose "End!"
    }
}

$UrlsFile = ".\urls.txt"
#$UrlsFile = "c:\sample\urls.txt"

Get-Content $UrlsFile | ForEach-Object {
    $Uri = $_.Trim('"')
    $Uri
} | Do-Cool-Parallel-Thingy-That-Takes-Uris-Via-Pipeline |
    # ?{ $_.StatusCode -ne "Request Error" }
    Format-List
