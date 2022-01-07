{
  projects = {
    ednkbd = {
      remote = "ssh://git@github.com/edeneast/ednkbd.git";
      tags = [ "app" ];
    };

    nightfox = {
      name = "nightfox.nvim";
      remote = "ssh://git@github.com/edeneast/nightfox.nvim.git";
      tags = [ "plugins" ];
    };

    repo = {
      remote = "ssh://git@github.com/edeneast/repo.git";
      tags = [ "app" ];
    };
  };

  tags = {
    app = {
      path = "app";
    };

    plugins = {
      path = "plugins";
    };

    site = {
      path = "site";
    };
  };
}
