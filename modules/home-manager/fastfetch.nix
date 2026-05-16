{
  config,
  lib,
  ...
}:
{
  options = {
    fastfetch-config.enable = lib.mkEnableOption "enable fastfetch config";
  };

  config = lib.mkIf config.fastfetch-config.enable {
    programs.fastfetch = {
      inherit (config.theme.fastfetch) settings;
      enable = true;
    };
  };
}
