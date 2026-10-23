# fetch_esma_sources.ps1
# Downloads the ESMA / EU ESG Ratings Regulation source library listed in sources.csv.
# Needs nothing installed: runs on the Windows PowerShell 5.1 built into Windows 10/11 (PowerShell 7 also works).
#
# Easiest: double-click 1_DOWNLOAD_ALL.bat
# Manual:  powershell -NoProfile -ExecutionPolicy Bypass -File .\fetch_esma_sources.ps1
# Options: -Only L1-ESGR,L2-871   (download specific IDs)   -Force   (re-download everything)

param(
    [string[]]$Only = @(),
    [switch]$Force,
    [int]$TimeoutSec = 120
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # the progress bar makes Invoke-WebRequest very slow on PS 5.1

# TLS 1.2 for older Windows PowerShell defaults
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
} catch { }
# Use the Windows/corporate proxy with your logged-in credentials, if one is configured
try {
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
} catch { }

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$out = Join-Path $here 'esma_library'
$srcDir = Join-Path $out 'sources'
New-Item -ItemType Directory -Force -Path $srcDir | Out-Null

$Only = @($Only | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })   # accept "A,B" from the command line
$rows = @(Import-Csv -Path (Join-Path $here 'sources.csv'))
if ($Only.Count -gt 0) { $rows = @($rows | Where-Object { $Only -contains $_.id }) }
if ($rows.Count -eq 0) { Write-Host 'No sources matched.' -ForegroundColor Red; exit 1 }

$ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36 Edg/124.0'
$headers = @{ 'Accept' = '*/*'; 'Accept-Language' = 'en' }

function Test-PdfHeader([string]$path) {
    $fs = [System.IO.File]::OpenRead($path)
    try {
        $buf = New-Object byte[] 4
        $n = $fs.Read($buf, 0, 4)
        return ($n -eq 4 -and [System.Text.Encoding]::ASCII.GetString($buf) -eq '%PDF')
    } finally { $fs.Close() }
}

$log = [ordered]@{}
$okCount = 0; $skipCount = 0
$failed = New-Object System.Collections.ArrayList
$robot = New-Object System.Collections.ArrayList

Write-Host ("Downloading {0} sources into {1}" -f $rows.Count, $out) -ForegroundColor Cyan
Write-Host ''

foreach ($r in $rows) {
    $dest = Join-Path $srcDir $r.filename
    if ((Test-Path $dest) -and -not $Force) { $skipCount++; Write-Host ("  skip    {0,-18} already downloaded" -f $r.id); continue }

    $rec = [ordered]@{ id = $r.id; title = $r.title; url = $r.url; fetched_at = (Get-Date).ToUniversalTime().ToString('o') }
    try {
        Invoke-WebRequest -Uri $r.url -OutFile $dest -UserAgent $ua -Headers $headers -UseBasicParsing -TimeoutSec $TimeoutSec
        if ($dest.ToLower().EndsWith('.pdf') -and -not (Test-PdfHeader $dest)) {
            $htmlDest = [System.IO.Path]::ChangeExtension($dest, '.html')
            Move-Item -Force -Path $dest -Destination $htmlDest
            $dest = $htmlDest
            $rec.warning = 'expected a PDF but received a web page (possibly a robot check)'
            [void]$robot.Add($r)
        }
        $size = (Get-Item $dest).Length
        $rec.status = 'ok'; $rec.bytes = $size
        $rec.sha256 = (Get-FileHash -Algorithm SHA256 -Path $dest).Hash.ToLower()
        $rec.file = 'sources/' + (Split-Path -Leaf $dest)
        $okCount++
        Write-Host ("  ok      {0,-18} {1,12:N0} bytes" -f $r.id, $size) -ForegroundColor Green
    } catch {
        $msg = $_.Exception.Message
        $rec.status = 'failed'; $rec.error = $msg
        if (Test-Path $dest) { Remove-Item -Force $dest }
        [void]$failed.Add($r)
        Write-Host ("  FAILED  {0,-18} {1}" -f $r.id, $msg) -ForegroundColor Red
    }
    $log[$r.id] = $rec
    Start-Sleep -Milliseconds 500
}

# merge with an existing log so re-runs keep history of earlier successes
$logPath = Join-Path $out 'fetch-log.json'
$merged = [ordered]@{}
if (Test-Path $logPath) {
    try {
        $old = Get-Content -Raw -Path $logPath | ConvertFrom-Json
        foreach ($p in $old.PSObject.Properties) { $merged[$p.Name] = $p.Value }
    } catch { }
}
foreach ($k in $log.Keys) { $merged[$k] = $log[$k] }
($merged | ConvertTo-Json -Depth 4) | Set-Content -Path $logPath -Encoding UTF8
Copy-Item -Force -Path (Join-Path $here 'sources.csv') -Destination (Join-Path $out 'source-manifest.csv')

Write-Host ''
Write-Host ("Done: {0} downloaded, {1} failed, {2} already present." -f $okCount, $failed.Count, $skipCount) -ForegroundColor Cyan

if ($robot.Count -gt 0) {
    Write-Host ''
    Write-Host 'These came back as web pages instead of PDFs (robot check). Run 2_FIX_WITH_BROWSER.bat, or open the links and save the PDFs:' -ForegroundColor Yellow
    foreach ($r in $robot) { Write-Host ("  {0}: {1}" -f $r.id, $r.url) }
}
if ($failed.Count -gt 0) {
    Write-Host ''
    Write-Host 'These failed. Run 2_FIX_WITH_BROWSER.bat, or download them by hand:' -ForegroundColor Yellow
    foreach ($r in $failed) { Write-Host ("  {0}: {1}" -f $r.id, $r.url) }
}

if (($okCount + $skipCount) -gt 0) {
    $zip = Join-Path $here 'esma_library.zip'
    if (Test-Path $zip) { Remove-Item -Force $zip }
    Compress-Archive -Path $out -DestinationPath $zip
    Write-Host ''
    Write-Host ("Created {0}  ->  send this file back to Claude." -f $zip) -ForegroundColor Cyan
    if ($failed.Count -gt 0 -or $robot.Count -gt 0) { exit 2 } else { exit 0 }
}
Write-Host ''
Write-Host 'Nothing was downloaded. Check your internet connection or proxy and try again.' -ForegroundColor Red
exit 1
