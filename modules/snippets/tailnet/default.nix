{lib, ...}: {
  options.my.snippets.tailnet = {
    name = lib.mkOption {
      default = "cerberus-tilapia.ts.net";
      description = "Tailnet name.";
      type = lib.types.str;
    };
  };
}
