#!/bin/sh
echo ::group::Autostarting cloudflared for Linux
nohup cloudflared tunnel run > ${RUNNER_TEMP}/cloudflared.log 2>&1 &
echo $! > ${RUNNER_TEMP}/cloudflared.pid
echo ::endgroup::