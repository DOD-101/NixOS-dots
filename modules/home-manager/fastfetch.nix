{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    fastfetch-config.enable = lib.mkEnableOption "enable fastfetch config";
  };

  config = lib.mkIf config.fastfetch-config.enable {
    home.file.".config/fastfetch/config.jsonc".source = ../../resources/fastfetch/fastfetch.jsonc;
    home.packages = with pkgs; [
      fastfetch
    ];
  };
}
