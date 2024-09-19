$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Write-Host ::group::Autostarting cloudflared for Windows
Start-Process "cloudflared" "--pidfile $env:RUNNER_TEMP/cloudflared.pid --logfile $env:RUNNER_TEMP/cloudflared.log tunnel run $(if ($env:url -ne 'false') {Write-Output "--url "$env:url""})"
Write-Host ::endgroup::