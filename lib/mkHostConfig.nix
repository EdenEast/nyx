{ lib, ... }:

{
  # Creates a host configuration that can them be used by either the mkHomeConfiguration, or mkSystemConfiguration
  # functions. These are internal abstractions.
  mkHostConfig = name: { system, config }:
    lib.nameValuePair name ({ ... }: {
      imports = [
        (import ../home/modules)
        (import ../home/profiles)
        (config)
      ];
    });
}
