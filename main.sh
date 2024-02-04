#!/usr/bin/env bash
set -e
if [[ $RUNNER_DEBUG == 1 ]]; then set -x; fi

export GH_TOKEN=$INPUT_CLOUDFLARED_TOKEN

temp_dir="$RUNNER_TEMP/$RANDOM"
mkdir "$temp_dir"
pushd "$temp_dir"

versions=$(gh release list \
  --repo cloudflare/cloudflared \
  --exclude-drafts \
  --exclude-pre-releases \
  --limit 1000 \
  | cut -f1)

version=$(node "$GITHUB_ACTION_PATH/semver.js" \
  --range "$range" $versions \
  | tail -n1)

case $(uname -m) in
  x86_64) node_arch="x64";;
  aarch64) node_arch="arm64";;
  *) echo "Unknown arch $(uname -m)"; exit 1;;
esac

tool_cache_dir="$RUNNER_TOOL_CACHE/cloudflared/$version/$node_arch"
echo "cache-hit=$(test -d "$tool_cache_dir")" >> "$GITHUB_OUTPUT"
if [[ ! -d $tool_cache_dir ]]; then
  case $(uname -sm) in
    Linux x86_64) target="linux-amd64";;
    Linux aarch64) target="linux-arm64";;
    MINGW64_NT-* x86_64) target="windows-amd64";;
    *) echo "Unknown OS/arch $(uname -sm)"; exit 1;;
  esac

  if [ "$OS" = "Windows_NT" ]; then
    exe_ext=".exe"
  fi

  file="cloudflared-$target$exe_ext"

  url="https://github.com/cloudflare/cloudflared/releases/download/$version/$file"
  echo "Fetching $file v$version from $url"
  wget "$url"
  chmod +x "$file"
  mkdir "$tool_cache_dir"
  mv "$file" "$tool_cache_dir/cloudflared$exe_ext"
fi

echo "$tool_cache_dir" >> "$GITHUB_PATH"
echo "cloudflared-version=$version" >> "$GITHUB_OUTPUT"
echo "✅ Cloudflare Tunnel Client v$version installed!"