#!/usr/bin/env bash
set -e

kill "$(< "$RUNNER_TEMP/cloudflared.pid")"

echo "::group::cloudflared"
cat "$RUNNER_TEMP/cloudflared.log"
echo "::endgroup::"

if [[ -f "$RUNNER_TEMP/run.sh" ]]; then
    kill "$(< "$RUNNER_TEMP/run.pid")"

    echo "::group::$(cat "$RUNNER_TEMP/run.sh" | head -n1)"
    cat "$RUNNER_TEMP/run.log"
    echo "::endgroup::"
fi