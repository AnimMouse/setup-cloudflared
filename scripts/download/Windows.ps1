$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
Set-StrictMode -Version Latest
Write-Host ::group::Downloading cloudflared $env:version for Windows
New-Item cloudflared -ItemType Directory -Force
Invoke-WebRequest $env:GITHUB_SERVER_URL/cloudflare/cloudflared/releases/download/$env:version/cloudflared-windows-amd64.exe -OutFile cloudflared\cloudflared.exe
Write-Host ::endgroup::