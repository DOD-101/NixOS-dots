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
      enable = true;
      settings = {
        programs.fastfetch = {
          enable = true;
          settings = config.theme.fastfetch.settings;
        };
      };
    };
  };
}
