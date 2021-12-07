{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "_types_node___node_16.11.6.tgz";
      path = fetchurl {
        name = "_types_node___node_16.11.6.tgz";
        url = "https://registry.yarnpkg.com/@types/node/-/node-16.11.6.tgz";
        sha1 = "6bef7a2a0ad684cf6e90fcfe31cecabd9ce0a3ae";
      };
    }
    {
      name = "_types_prettier___prettier_2.4.1.tgz";
      path = fetchurl {
        name = "_types_prettier___prettier_2.4.1.tgz";
        url = "https://registry.yarnpkg.com/@types/prettier/-/prettier-2.4.1.tgz";
        sha1 = "e1303048d5389563e130f5bdd89d37a99acb75eb";
      };
    }
    {
      name = "core_d___core_d_3.2.0.tgz";
      path = fetchurl {
        name = "core_d___core_d_3.2.0.tgz";
        url = "https://registry.yarnpkg.com/core_d/-/core_d-3.2.0.tgz";
        sha1 = "c4cbed5b69684d04a6b5f880935be1659601151c";
      };
    }
    {
      name = "has_flag___has_flag_4.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_4.0.0.tgz";
        url = "https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz";
        sha1 = "944771fd9c81c81265c4d6941860da06bb59479b";
      };
    }
    {
      name = "nanolru___nanolru_1.0.0.tgz";
      path = fetchurl {
        name = "nanolru___nanolru_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/nanolru/-/nanolru-1.0.0.tgz";
        sha1 = "0a5679cd4e4578c4ca3741e610b71c4c9b5afaf8";
      };
    }
    {
      name = "prettier___prettier_2.4.1.tgz";
      path = fetchurl {
        name = "prettier___prettier_2.4.1.tgz";
        url = "https://registry.yarnpkg.com/prettier/-/prettier-2.4.1.tgz";
        sha1 = "671e11c89c14a4cfc876ce564106c4a6726c9f5c";
      };
    }
    {
      name = "supports_color___supports_color_8.1.1.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_8.1.1.tgz";
        url = "https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz";
        sha1 = "cd6fc17e28500cff56c1b86c0a7fd4a54a73005c";
      };
    }
    {
      name = "typescript___typescript_4.4.4.tgz";
      path = fetchurl {
        name = "typescript___typescript_4.4.4.tgz";
        url = "https://registry.yarnpkg.com/typescript/-/typescript-4.4.4.tgz";
        sha1 = "2cd01a1a1f160704d3101fd5a58ff0f9fcb8030c";
      };
    }
  ];
}
