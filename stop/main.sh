#!/usr/bin/env bash
set -e

if [ "$OS" = "Windows_NT" ]; then
    pwsh -c '
        cd "$env:RUNNER_TEMP"
        (Get-Process -Id $(Get-Content cloudflared.pid)).CloseMainWindow()
        Wait-Process -Id $(Get-Content cloudflared.pid)
    '
else
    kill "$(< "$RUNNER_TEMP/cloudflared.pid")"
fi

echo "::group::cloudflared"
cat "$RUNNER_TEMP/cloudflared.log"
echo "::endgroup::"

if [[ -f "$RUNNER_TEMP/run.sh" ]]; then
    if [ "$OS" = "Windows_NT" ]; then
        pwsh -c '
            cd "$env:RUNNER_TEMP"
            (Get-Process -Id $(Get-Content run.pid)).CloseMainWindow()
            Wait-Process -Id $(Get-Content run.pid)
        '
    else
        kill "$(< "$RUNNER_TEMP/run.pid")"
    fi

    echo "::group::$(cat "$RUNNER_TEMP/run.sh" | head -n1)"
    cat "$RUNNER_TEMP/run.log"
    echo "::endgroup::"
fi