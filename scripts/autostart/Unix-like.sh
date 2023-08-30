#!/bin/sh
set -eu
echo ::group::Autostarting cloudflared for $RUNNER_OS
nohup cloudflared --pidfile $RUNNER_TEMP/cloudflared.pid --logfile $RUNNER_TEMP/cloudflared.log tunnel run &
echo ::endgroup::