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
      inputs.igneous-md.packages."${pkgs.system}".igneous-md-release
    ];

    xdg.configFile."igneous-md/css/_${config.theme.name}.css".text = config.theme.igneous-md;

    shell.completions = [ "igneous-md completions @shell@" ];
  };
}
