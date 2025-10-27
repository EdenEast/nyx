{self, ...}: {
  imports = [
    ./desktop
    ./profiles
    ./programs
    ./services
    # self.inputs.niri-flake.homeModules.config
    self.inputs.zen-browser.homeModules.beta
  ];
}
