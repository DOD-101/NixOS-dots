{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    fastfetch-config.enable = lib.mkEnableOption "enable foot config";
  };

  config = lib.mkIf config.fastfetch-config.enable {
    home.file.".config/fastfetch/config.jsonc".source = ./fastfetch.jsonc;
    home.packages = with pkgs; [
      fastfetch
    ];
  };
}
