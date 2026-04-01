{config, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = ../../secrets/tailscale-auth.age;
    cloudflareDnsCredentials.file = ../../secrets/cloudflare-dns-credentials.age;
    golinkAuthKey = {
      inherit (config.services.golink) group;
      file = ../../secrets/tailscale-auth.age;
      owner = config.services.golink.user;
    };
    cloudflareTunnel.file = ../../secrets/cloudflare-tunnel-credentials.age;
  };
}
