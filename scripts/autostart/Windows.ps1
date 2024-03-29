$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Write-Host ::group::Autostarting cloudflared for Windows
Start-Process "cloudflared" "--pidfile $env:RUNNER_TEMP/cloudflared.pid --logfile $env:RUNNER_TEMP/cloudflared.log tunnel run"
Write-Host ::endgroup::