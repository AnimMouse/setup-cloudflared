# Setup cloudflared for GitHub Actions
Setup [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared) for GitHub Actions.

This action installs [cloudflared](https://github.com/cloudflare/cloudflared) for use in actions by installing it on tool cache using [AnimMouse/tool-cache](https://github.com/AnimMouse/tool-cache).

This action will automatically sign in and start Cloudflare Tunnel.

Other virtual environments besides Ubuntu are not supported yet.

[Test page for setup-cloudflared](https://setup-cloudflared-test.114913.xyz/)

## Usage
1. Paste the contents of the cert.prm file to `CLOUDFLARE_TUNNEL_CERTIFICATE` secret. No need to encode it to base64 as it is already in base64.
2. Encode the JSON credential in base64 using this command `base64 -w 0 <cloudflare-tunnel-id>.json` and paste it to `CLOUDFLARE_TUNNEL_CREDENTIAL` secret.
3. At the config.yml, set `credentials-file:` to `/home/runner/.cloudflared/<cloudflare-tunnel-id>.json`
4. Encode the config.yml in base64 using this command `base64 -w 0 config.yml` and paste it to `CLOUDFLARE_TUNNEL_CONFIGURATION` secret.
5. Add the Cloudflare Tunnel ID to `CLOUDFLARE_TUNNEL_ID` secret.

To gracefully shutdown Cloudflare Tunnel after being started in the background, use the `AnimMouse/setup-cloudflared/shutdown` action as composite actions does not support `post:` yet.\
The `Shutdown Cloudflare Tunnel` action should have `if: always()` so that it will run even if the workflow failed or canceled.

```yaml
steps:
  - name: Setup Cloudflare Tunnel
    uses: AnimMouse/setup-cloudflared@v1
    with:
      cloudflare_tunnel_certificate: ${{ secrets.CLOUDFLARE_TUNNEL_CERTIFICATE }}
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      
    - name: Start Python HTTP server
      run: timeout 5m python -m http.server 8000 || true
      
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
      cloudflare_tunnel_certificate: ${{ secrets.CLOUDFLARE_TUNNEL_CERTIFICATE }}
      cloudflare_tunnel_credential: ${{ secrets.CLOUDFLARE_TUNNEL_CREDENTIAL }}
      cloudflare_tunnel_configuration: ${{ secrets.CLOUDFLARE_TUNNEL_CONFIGURATION }}
      cloudflare_tunnel_id: ${{ secrets.CLOUDFLARE_TUNNEL_ID }}
      autostart: false
      
    - name: Manually start Cloudflare Tunnel
      run: timeout 5m cloudflared tunnel run || true
```