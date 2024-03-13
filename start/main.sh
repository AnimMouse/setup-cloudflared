#!/usr/bin/env bash
set -ex

nohup cloudflared \
    --pidfile "$RUNNER_TEMP/cloudflared.pid" \
    --logfile "$RUNNER_TEMP/cloudflared.log" \
    tunnel --url "$INPUT_URL" &

if [[ -n $INPUT_RUN ]]; then
    bash -ec "$INPUT_RUN" > "$RUNNER_TEMP/run.log" 2>&1 &
    echo $! > "$RUNNER_TEMP/run.pid"
    echo "$INPUT_RUN" > "$RUNNER_TEMP/run.sh"
fi