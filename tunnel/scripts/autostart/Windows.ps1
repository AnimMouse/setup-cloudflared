$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Write-Host ::group::Autostarting cloudflared for Windows
if ($env:url -eq 'false') {
  Start-Process "cloudflared" "--pidfile $env:RUNNER_TEMP/cloudflared.pid --logfile $env:RUNNER_TEMP/cloudflared.log tunnel run"
}
else {
  Start-Process "cloudflared" "--pidfile $env:RUNNER_TEMP/cloudflared.pid --logfile $env:RUNNER_TEMP/cloudflared.log tunnel --url $env:url"
}
Write-Host ::endgroup::