{self, ...}: {
  age.secrets = {
    cloudflared-matrix.file = "${self.secretsDir}/cloudflared-tunnel-matrix.age";
    tailscaleAuthKey.file = ../../secrets/tailscale-auth.age;
  };
}
