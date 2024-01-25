# Set strict error handling
Set-StrictMode -Version Latest

# Terminate cloudflared process
$cloudflaredPid = Get-Content "$env:RUNNER_TEMP\cloudflared.pid"
Stop-Process -Id $cloudflaredPid -Force

# Display cloudflared log
Write-Host "::group::cloudflared"
Get-Content "$env:RUNNER_TEMP\cloudflared.log"
Write-Host "::endgroup::"

# Terminate and display run.sh logs if the file exists
if (Test-Path "$env:RUNNER_TEMP\run.sh") {
    $runPid = Get-Content "$env:RUNNER_TEMP\run.pid"
    Stop-Process -Id $runPid -Force

    $runCommand = Get-Content "$env:RUNNER_TEMP\run.sh" | Select-Object -First 1
    Write-Host "::group::$runCommand"
    Get-Content "$env:RUNNER_TEMP\run.log"
    Write-Host "::endgroup::"
}
