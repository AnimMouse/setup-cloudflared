#!/bin/sh
echo ::group::Downloading latest cloudflared for Linux
aria2c -x 16 "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
chmod +x cloudflared-linux-amd64
mkdir cloudflared
mv cloudflared-linux-amd64 ./cloudflared/cloudflared
echo ::endgroup::