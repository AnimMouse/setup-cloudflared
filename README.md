# Setup cloudflared for GitHub Actions
Setup [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared) for GitHub Actions.

This action installs [cloudflared](https://github.com/cloudflare/cloudflared) for use in actions by installing it on tool cache using [AnimMouse/tool-cache](https://github.com/AnimMouse/tool-cache).

This action will automatically sign in and start Cloudflare Tunnel.

Other virtual environments besides Ubuntu are not supported yet.

[Test page for setup-cloudflared](https://setup-cloudflared.0000004.xyz) (This will only work when the test action is running.)

## Usage
1. Encode the JSON credential in base64 using this command `base64 -w 0 <cloudflare-tunnel-id>.json` and paste it to `CLOUDFLARE_TUNNEL_CREDENTIAL` secret.
2. At the config.yaml, set `credentials-file:` to `/home/runner/.cloudflared/<cloudflare-tunnel-id>.json`
3. Encode the config.yaml in base64 using this command `base64 -w 0 config.yaml` and paste it to `CLOUDFLARE_TUNNEL_CONFIGURATION` secret.
4. Add the Cloudflare Tunnel ID to `CLOUDFLARE_TUNNEL_ID` secret.

To gracefully shutdown Cloudflare Tunnel after being started in the background, use the `AnimMouse/setup-cloudflared/shutdown` action as composite actions does not support `post:` yet.\
The `Shutdown Cloudflare Tunnel` action should have `if: always()` so that it will run even if the workflow failed or canceled.

```yaml
steps:
  - name: Setup Cloudflare Tunnel
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      
    - name: Start Python HTTP server
      run: timeout 5m python -m http.server 8080 || true
      
    - name: Shutdown and view logs of Cloudflare Tunnel
      if: always()
      uses: AnimMouse/setup-cloudflared/shutdown@v1
```

If you don't want to autostart Cloudflare Tunnel, set `autostart:` to `false`.

```yaml
steps:
  - name: Setup Cloudflare Tunnel
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      autostart: false
      
    - name: Manually start Cloudflare Tunnel
      run: timeout 5m cloudflared tunnel run || true
```

### Example config.yaml file
```yaml
url: http://localhost:8080
tunnel: deadbeef-1234-4321-abcd-123456789abc
credentials-file: /home/runner/.cloudflared/deadbeef-1234-4321-abcd-123456789abc.json
```

### Similar actions
1. [vmactions/cf-tunnel](https://github.com/vmactions/cf-tunnel)
2. [apogiatzis/ngrok-tunneling-action](https://github.com/apogiatzis/ngrok-tunneling-action)
3. [vmactions/ngrok-tunnel](https://github.com/vmactions/ngrok-tunnel)