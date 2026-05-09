{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    igneous-config.enable = lib.mkEnableOption "enable igneous.md configuration";
  };

  config = lib.mkIf config.igneous-config.enable {
    home.packages = [
      inputs.igneous-md.packages."${pkgs.stdenv.hostPlatform.system}".igneous-md-release
    ];

    xdg.configFile = builtins.listToAttrs (
      lib.imap0 (i: v: {
        name = "igneous-md/css/_${toString i}${config.theme.name}.css";
        value = {
          text = v;
        };
      }) config.theme.igneous-md
    );

    shell.completions = [ "igneous-md completions @shell@" ];
  };
}
