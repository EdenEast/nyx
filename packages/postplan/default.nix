_: {
  perSystem = {pkgs, ...}: {
    packages = {
      postplan = pkgs.buildNpmPackage rec {
        pname = "postplan";
        version = "0.0.4";

        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/postplan/-/postplan-${version}.tgz";
          hash = "sha512-ctOrqRP+MhkhbUi9xCPO8k9lYLbwzWs7IfKnBy1nTiFeLtWVLntWdvII4kIhtNJSioa+b4nOx/8+qAYN2aBUvg==";
        };

        postPatch = ''
          cp ${./package-lock.json} package-lock.json
        '';

        npmDepsHash = "sha256-t1T7m/e6Gt8UQ4y5PQdKdABJ9KvG8zX2d/KVv58QX6k=";

        dontNpmBuild = true;
      };
    };
  };
}
