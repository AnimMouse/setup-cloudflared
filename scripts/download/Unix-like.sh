#!/bin/sh
set -eu
echo ::group::Downloading cloudflared $version for $RUNNER_OS
mkdir -p cloudflared
if [ $RUNNER_OS = macOS ]
then
  wget -qO- $GITHUB_SERVER_URL/cloudflare/cloudflared/releases/download/$version/cloudflared-darwin-amd64.tgz | tar -xz -C cloudflared cloudflared
else
  wget -q -O cloudflared/cloudflared $GITHUB_SERVER_URL/cloudflare/cloudflared/releases/download/$version/cloudflared-linux-amd64
  chmod +x cloudflared/cloudflared
fi
echo ::endgroup::