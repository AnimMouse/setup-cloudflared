# Setup Cloudflare Tunnel client

🚛 Installs `cloudflared` for GitHub Actions

<div align="center">

![](https://i.imgur.com/fCYSI7n.png)

</div>

📦 Downloads & installs the `cloudflared` binary \
🚀 Zero-config to get started; supports [`config.yml`](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/#4-create-a-configuration-file) for advanced use \
▶️ Includes start & stop sub-actions for [Cloudflare Quick Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/do-more-with-tunnels/trycloudflare/)  \
🌈 Works on Windows, macOS, and Linux runners

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

**🚀 Here's what you want:**

```yml
on: push
jobs:
  job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: AnimMouse/setup-cloudflared@v2
      - uses: AnimMouse/setup-cloudflared/start@v2
        with:
          run: npx -y serve
          url: http://localhost:3000
      - run: sleep 100
      - uses: AnimMouse/setup-cloudflared/stop@v2 # OPTIONAL
```

[📚 Read more about Cloudflare Tunnels and the Cloudflare Tunnel Client](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)

### Options

There's only one option so far. If you want to see automatic login or similar,
just open an Issue! ❤️

- **`cloudflared-version`:** Specifies which version of cloudflared to install from the GitHub Releases page. Note that cloudflared uses a date-based versioning scheme. The default value for this field is `latest` which will automagically default to the latest GitHub Release. This field does support semver ranges like `^2023.0.0`.

- **`cloudflared-token`:** The GitHub token to use when fetching the version list from [cloudflare/cloudflared](https://github.com/cloudflare/cloudflared/releases). You shouldn't have to touch this. The default is the `github.token` if you're on github.com or unauthenticated (rate limited) if you're not on github.com.

## Development

![Bash](https://img.shields.io/static/v1?style=for-the-badge&message=Bash&color=4EAA25&logo=GNU+Bash&logoColor=FFFFFF&label=)
![PowerShell](https://img.shields.io/static/v1?style=for-the-badge&message=PowerShell&color=5391FE&logo=PowerShell&logoColor=FFFFFF&label=)

This GitHub action is build using Bash.

Ocassionally you may need to regenerate the self-contained `semver.mjs` CLI app. You can use `ncc`, `vite`, or `bun` to bundle it. The point of this is to bundle a semver range parser so that we can support `cloudflared-version: 2023.x` or other similar semver range expressions.

```sh
cd "$(mktemp)"
bun init -y
bun install semver
bun build node_modules/semver/bin/semver.js --target=node --outfile=semver.mjs
# semver.mjs is now a self-contained script. Run it like 'node semver.mjs'.
```



# Setup cloudflared for GitHub Actions

Setup [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared) for GitHub Actions.

This action installs [cloudflared](https://github.com/cloudflare/cloudflared) for use in actions by installing it on tool cache using [AnimMouse/tool-cache](https://github.com/AnimMouse/tool-cache).

This action will automatically sign in and start Cloudflare Tunnel.

This GitHub action participated on [GitHub Actions Hackathon 2021](https://dev.to/animmouse/expose-your-web-server-on-github-actions-to-the-internet-using-cloudflare-tunnel-ego), but sadly, it lost.

Test page for setup-cloudflared: https://setup-cloudflared.44444444.xyz (This will only work when the test action is running.)

## Usage

1. Encode the JSON credential in Base64 using this command `base64 -w 0 <cloudflare-tunnel-id>.json` and paste it to `CLOUDFLARE_TUNNEL_CREDENTIAL` secret.
2. At the config.yaml, set `credentials-file:` to:
   1. Ubuntu: `/home/runner/.cloudflared/<cloudflare-tunnel-id>.json`
   2. Windows: `C:\Users\runneradmin\.cloudflared\<cloudflare-tunnel-id>.json`
   3. macOS: `/Users/runner/.cloudflared/<cloudflare-tunnel-id>.json`
3. Encode the config.yaml in Base64 using this command `base64 -w 0 config.yaml` and paste it to `CLOUDFLARE_TUNNEL_CONFIGURATION` secret.
4. Add the Cloudflare Tunnel ID to `CLOUDFLARE_TUNNEL_ID` secret.

To gracefully shutdown Cloudflare Tunnel after being started in the background, use the `AnimMouse/setup-cloudflared/shutdown` action as composite actions does not support `post:` yet.\
The `Shutdown Cloudflare Tunnel` action should have `if: always()` so that it will run even if the workflow failed or canceled.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}

    - name: Start Python HTTP server
      run: timeout 5m python -m http.server 8080 || true

    - name: Shutdown and view logs of cloudflared
      if: always()
      uses: AnimMouse/setup-cloudflared/shutdown@v1
```

If you don't want to autostart Cloudflare Tunnel, set `autostart:` to `false`.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      autostart: false

    - name: Manually start cloudflared
      run: timeout 5m cloudflared tunnel run || true
```

### Specific version

You can specify the version you want. By default, this action downloads the latest version if version is not specified.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      version: 2023.8.1
```

### GitHub token

This action automatically uses a GitHub token in order to authenticate with GitHub API and avoid rate limiting. You can also specify your own read-only fine-grained personal access token.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      token: ${{ secrets.GH_PAT }}
```

### Example config.yaml file

Ubuntu:

```yaml
url: http://localhost:8080
tunnel: deadbeef-1234-4321-abcd-123456789abc
credentials-file: /home/runner/.cloudflared/deadbeef-1234-4321-abcd-123456789abc.json
```

Windows:

```yaml
url: http://localhost:8080
tunnel: deadbeef-1234-4321-abcd-123456789abc
credentials-file: C:\Users\runneradmin\.cloudflared\deadbeef-1234-4321-abcd-123456789abc.json
```

macOS:

```yaml
url: http://localhost:8080
tunnel: deadbeef-1234-4321-abcd-123456789abc
credentials-file: /Users/runner/.cloudflared/deadbeef-1234-4321-abcd-123456789abc.json
```

### Similar actions

1. [vmactions/cf-tunnel](https://github.com/vmactions/cf-tunnel)
2. [apogiatzis/ngrok-tunneling-action](https://github.com/apogiatzis/ngrok-tunneling-action)
3. [vmactions/ngrok-tunnel](https://github.com/vmactions/ngrok-tunnel)
4. [debugci/setup-cloudflared](https://github.com/debugci/setup-cloudflared)
