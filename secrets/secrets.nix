let
  isRoot = file: builtins.match "root_.*" file != null;
  isUser = file: !isRoot file;
  mkList = path: f:
    map (file: builtins.readFile "${path}/${file}")
    (builtins.filter f (builtins.attrNames (builtins.readDir path)));

  systems = mkList ./publicKeys isRoot;
  users = mkList ./publicKeys isUser;
  keys = systems ++ users;
in {
  "tailscale-auth.age".publicKeys = keys;
}
