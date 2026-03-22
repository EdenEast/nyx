{config, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = ../../secrets/tailscale-auth.age;
    cloudflareDnsCredentials.file = ../../secrets/cloudflare-dns-credentials.age;
    golinkAuthKey = {
      file = ../../secrets/tailscale-auth.age;
      group = config.services.golink.group;
      owner = config.services.golink.user;
    };
  };
}
