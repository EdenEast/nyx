let
  isRoot = file: builtins.match "root_.*" file != null;
  isUser = file: !isRoot file;
  mkList = path: f:
    map (file: builtins.readFile "${path}/${file}")
    (builtins.filter f (builtins.attrNames (builtins.readDir path)));

  systems = mkList ./publickeys isRoot;
  users = mkList ./publickeys isUser;
  keys = systems ++ users;
in {
}
