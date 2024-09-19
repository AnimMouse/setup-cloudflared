# Setup cloudflared for GitHub Actions
Setup [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared) for GitHub Actions.

This action installs [cloudflared](https://github.com/cloudflare/cloudflared) for use in actions by installing it on tool cache using [AnimMouse/tool-cache](https://github.com/AnimMouse/tool-cache).

This GitHub action participated in the [GitHub Actions Hackathon 2021](https://dev.to/animmouse/expose-your-web-server-on-github-actions-to-the-internet-using-cloudflare-tunnel-ego), but sadly, it lost.

Test page for setup-cloudflared: https://setup-cloudflared.44444444.xyz (This will only work when the test action is running.)

## Usage
To use `cloudflared`, run this action before `cloudflared`.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v2
    
  - name: Check cloudflared version
    run: cloudflared -v
```

### Cloudflare Tunnel Usage
Use Cloudflare Tunnel to expose servers running inside GitHub Actions to the Internet.

1. Encode the JSON credential in Base64 using this command `base64 -w 0 <cloudflare-tunnel-id>.json` and paste it to `CLOUDFLARE_TUNNEL_CREDENTIAL` secret.
2. Inside the config.yaml, set `credentials-file:` to:
   1. Ubuntu: `/home/runner/.cloudflared/<cloudflare-tunnel-id>.json`
   2. Windows: `C:\Users\runneradmin\.cloudflared\<cloudflare-tunnel-id>.json`
   3. macOS: `/Users/runner/.cloudflared/<cloudflare-tunnel-id>.json`
3. Encode the config.yaml in Base64 using this command `base64 -w 0 config.yaml` and paste it to `CLOUDFLARE_TUNNEL_CONFIGURATION` variable.
4. Add the Cloudflare Tunnel ID to `CLOUDFLARE_TUNNEL_ID` variable.

To gracefully shutdown Cloudflare Tunnel after being started in the background, use the `AnimMouse/setup-cloudflared/shutdown` action as composite actions does not support `post:` yet.\
The `Shutdown Cloudflare Tunnel` action should have `if: '! cancelled()'` so that it will run even if the workflow fails.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v2
    
  - name: Setup cloudflared tunnel
    uses: AnimMouse/setup-cloudflared/tunnel@v2
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ vars.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ vars.CLOUDFLARE_TUNNEL_ID }}
      
  - name: Start Python HTTP server
    run: timeout 5m python -m http.server 8080 || true
    
  - name: Shutdown and view logs of cloudflared
    if: '! cancelled()'
    uses: AnimMouse/setup-cloudflared/shutdown@v2
```

If you don't want to automatically start Cloudflare Tunnel in the background, set `autostart:` to `false`.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v2
    
  - name: Setup cloudflared tunnel
    uses: AnimMouse/setup-cloudflared/tunnel@v2
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ vars.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ vars.CLOUDFLARE_TUNNEL_ID }}
      autostart: false
      
  - name: Manually start cloudflared tunnel
    run: timeout 5m cloudflared tunnel run || true
```

### TryCloudflare Usage
You can use Cloudflare Tunnel without a Cloudflare account and a domain name. Your quick tunnel URL will appear on the Actions log.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v2
    
  - name: Setup cloudflared tunnel
    uses: AnimMouse/setup-cloudflared/tunnel@v2
    with:
      url: http://localhost:8080
      
  - name: Start Python HTTP server
    run: timeout 5m python -m http.server 8080 || true
    
  - name: Shutdown and view logs of cloudflared
    if: '! cancelled()'
    uses: AnimMouse/setup-cloudflared/shutdown@v2
```

### Specific version
You can specify the version you want. By default, this action downloads the latest version if the version is not specified.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v2
    with:
      version: 2024.2.1
```

### GitHub token
This action automatically uses a GitHub token in order to authenticate with the GitHub API and avoid rate limiting. You can also specify your own read-only fine-grained personal access token.

```yaml
steps:
  - name: Setup cloudflared
    uses: AnimMouse/setup-cloudflared@v2
    with:
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