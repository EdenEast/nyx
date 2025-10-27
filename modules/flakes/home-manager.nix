{self, ...}: {
  flake = {
    homeModules =
      {
        default = ../home;
        # desktop = ../home/desktop;
        # profiles = ../home/profiles;
        # programs = ../home/programs;
        # services = ../home/services;
        snippets = ../snippets;
        # users = self.lib.forAllNixFiles ../home/users (_: x: x);
      }
      // self.lib.forAllNixFiles ../home/users (_: x: x);
  };
}
