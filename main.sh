#!/bin/bash
set -e

export GH_TOKEN=$GITHUB_TOKEN

if [[ $RUNNER_OS == Linux ]]; then
  pushd "$(mktemp -d)"
  if [[ $INPUT_CLOUDFLARED_VERSION == latest ]]; then
    gh release download -R cloudflare/cloudflared -p cloudflared-linux-amd64.deb
  else
    gh release download -R cloudflare/cloudflared "$INPUT_CLOUDFLARED_VERSION" -p cloudflared-linux-amd64.deb
  fi
  sudo dpkg -i cloudflared-linux-amd64.deb
  popd
elif [[ $RUNNER_OS == Windows ]]; then
  if [[ $INPUT_CLOUDFLARED_VERSION == latest ]]; then
    choco install cloudflared
  else
    choco install cloudflared --version "$INPUT_CLOUDFLARED_VERSION"
  fi
elif [[ $RUNNER_OS == macOS ]]; then
  if [[ $INPUT_CLOUDFLARED_VERSION == latest ]]; then
    brew install cloudflare/cloudflare/cloudflared
  else
    brew install "cloudflare/cloudflare/cloudflared@$INPUT_CLOUDFLARED_VERSION"
  fi
else
  echo "Not Windows, Linux, or macOS. Don't know how to install cloudflared." >&2
  exit 1
fi

mkdir ~/.cloudflared
echo "$cloudflare_tunnel_credential" | base64 -d > ~/.cloudflared/$cloudflare_tunnel_id.json
echo "$cloudflare_tunnel_configuration" | base64 -d > ~/.cloudflared/config.yaml
