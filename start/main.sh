#!/usr/bin/env bash
set -e

if [[ -e "$RUNNER_TEMP/cloudflared.log" ]]; then
    echo "$RUNNER_TEMP/cloudflared.log already exists!" >&2
    exit 1
fi
if [[ -e "$RUNNER_TEMP/cloudflared.pid" ]]; then
    echo "$RUNNER_TEMP/cloudflared.pid already exists!" >&2
    exit 1
fi
if [ "$OS" = "Windows_NT" ]; then
    pwsh -c 'Start-Process "cloudflared" "--pidfile $env:RUNNER_TEMP/cloudflared.pid --logfile $env:RUNNER_TEMP/cloudflared.log tunnel run"'
else
    nohup cloudflared \
        --pidfile "$RUNNER_TEMP/cloudflared.pid" \
        --logfile "$RUNNER_TEMP/cloudflared.log" \
        tunnel --url "$INPUT_URL" &
fi

if [[ -n $INPUT_RUN ]]; then
    if [[ -e "$RUNNER_TEMP/run.log" ]]; then
        echo "$RUNNER_TEMP/run.log already exists!" >&2
        exit 1
    fi
    if [[ -e "$RUNNER_TEMP/run.pid" ]]; then
        echo "$RUNNER_TEMP/run.pid already exists!" >&2
        exit 1
    fi
    if [[ -e "$RUNNER_TEMP/run.sh" ]]; then
        echo "$RUNNER_TEMP/run.sh already exists!" >&2
        exit 1
    fi
    bash -ec "$INPUT_RUN" > "$RUNNER_TEMP/run.log" 2>&1 &
    echo $! > "$RUNNER_TEMP/run.pid"
    echo "$INPUT_RUN" > "$RUNNER_TEMP/run.sh"
fi