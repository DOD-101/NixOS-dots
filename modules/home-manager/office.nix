{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.office-config = {
    enable = lib.mkEnableOption "enable office config";
    teams.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable teams for linux, true by default";
    };
  };

  config = lib.mkIf config.office-config.enable {
    home.packages =
      with pkgs;
      [
        libreoffice
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US
        hunspellDicts.es_ES

        xournalpp
      ]
      ++ lib.optionals config.office-config.teams.enable [
        teams-for-linux
      ];
  };
}
