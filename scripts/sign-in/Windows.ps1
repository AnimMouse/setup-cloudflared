$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Write-Host ::group::Signing in to Cloudflare Tunnel client
New-Item $env:USERPROFILE\.cloudflared -ItemType Directory -Force
$cloudflare_tunnel_credential = [Convert]::FromBase64String($env:cloudflare_tunnel_credential)
$cloudflare_tunnel_configuration = [Convert]::FromBase64String($env:cloudflare_tunnel_configuration)
[IO.File]::WriteAllBytes("$env:USERPROFILE\.cloudflared\$env:cloudflare_tunnel_id.json", $cloudflare_tunnel_credential)
[IO.File]::WriteAllBytes("$env:USERPROFILE\.cloudflared\config.yaml", $cloudflare_tunnel_configuration)
Write-Host ::endgroup::