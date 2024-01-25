# Set strict error handling
Set-StrictMode -Version Latest

# Start cloudflared in the background, capturing output and errors
Start-Process -FilePath "cloudflared" -ArgumentList @(
    "--pidfile", "$env:RUNNER_TEMP\cloudflared.pid",
    "--logfile", "$env:RUNNER_TEMP\cloudflared.log",
    "tunnel", "--url", "$env:INPUT_URL"
) -NoNewWindow -Wait -RedirectStandardOutput "$env:RUNNER_TEMP\cloudflared.log" -RedirectStandardError "$env:RUNNER_TEMP\cloudflared.log"

# Run the specified command if provided
if ($env:INPUT_RUN) {
    Start-Process -FilePath "powershell.exe" -ArgumentList @(
        "-Command", "$env:INPUT_RUN"
    ) -NoNewWindow -Wait -RedirectStandardOutput "$env:RUNNER_TEMP\run.log" -RedirectStandardError "$env:RUNNER_TEMP\run.log"
    $processId = Get-Process -Id $PID | Select-Object -ExpandProperty ParentProcessId
    $processId | Out-File "$env:RUNNER_TEMP\run.pid"
    $env:INPUT_RUN | Out-File "$env:RUNNER_TEMP\run.sh"
}
