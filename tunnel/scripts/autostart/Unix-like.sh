#!/bin/sh
set -eu
echo ::group::Autostarting cloudflared tunnel
if [ "$url" = false ]
then
  nohup cloudflared --pidfile $RUNNER_TEMP/cloudflared.pid --logfile $RUNNER_TEMP/cloudflared.log tunnel run &
else
  nohup cloudflared --pidfile $RUNNER_TEMP/cloudflared.pid --logfile $RUNNER_TEMP/cloudflared.log tunnel --url "$url" &
fi
echo ::endgroup::