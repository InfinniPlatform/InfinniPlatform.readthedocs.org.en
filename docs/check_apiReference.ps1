$warnings = 0
$apiFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot 'source/_docfx/api/reference') -Filter '*.html' | ForEach-Object { $_.Name }
$docFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot 'source') -Filter '*.rst' -Recurse

foreach ($docFile in $docFiles)
{
    $docContent = Get-Content $docFile.FullName

    $references = $docContent | Select-String '(?mi)^.*?\:\s*\/api\/reference\/(.*)\.html.*?$' -AllMatches `
        | ForEach-Object { $_.Matches.Groups[1] } `
        | ForEach-Object { $_.Value + '.html' }

    foreach ($ref in $references)
    {
        if ($apiFiles -notcontains $ref)
        {
            Write-Host "File '$($docFile.FullName)' contains bad reference '$ref'." -ForegroundColor Yellow
            $warnings += 1
        }
    }
}

if ($warnings -gt 0)
{
    Write-Host "Documentation contains $warnings bad references to the API." -ForegroundColor Red
    exit 1
}

Write-Host 'All references to the API are actual.' -ForegroundColor Green
exit 0
