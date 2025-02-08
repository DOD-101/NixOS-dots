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
    home.packages = with pkgs; [
      fastfetch
    ];
  };
}
