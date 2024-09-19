#!/bin/sh
set -eu
echo ::group::Autostarting cloudflared tunnel
nohup cloudflared --pidfile $RUNNER_TEMP/cloudflared.pid --logfile $RUNNER_TEMP/cloudflared.log tunnel run $(if [ "$url" != false ]; then echo "--url "$url""; fi) &
echo ::endgroup::