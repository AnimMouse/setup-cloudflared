#!/bin/sh
echo ::group::Signing in to Cloudflare Tunnel client
mkdir ~/.cloudflared/
echo $cloudflare_tunnel_credential | base64 -d > ~/.cloudflared/${cloudflare_tunnel_id}.json
echo $cloudflare_tunnel_configuration | base64 -d > ~/.cloudflared/config.yaml
echo ::endgroup::