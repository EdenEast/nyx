# Secrets

Secrets are managed using [ragenix](https://github.com/yaxitech/ragenix) which is a rust replacement for
[agenix](https://github.com/ryantm/agenix). Understanding how this works and getting this setup was a challenge, so I
wanted to document it here for future reference.

## Adding a new host

Only hosts that have their public keys added to `./publickeys/root_XXX.pub`. Can interact with secrets. If a host was to
be added to this list it would not be able to interact with secrets as the secrets have not been `keyed` for it. This
stops someone from cloning this repo and adding their hosts key pair to this repo and then decrypting the secrets.

To add a new host to this list you need another host that has already been added. Once you have installed NixOS on the
new host you can either copy the machines publish ssh key located at `/etc/ssh/ssh_host_ed25519_key.pub` or you can use
`ssh-keyscan` to list the public key

```
ssh-keyscan -t ed25519 <ip_address>
```

Once the public key has been added to `./publickeys/root_${$HOSTNAME}.pub` you can then `rekey` all the secrets.

```bash
ragenix --rekey
```
