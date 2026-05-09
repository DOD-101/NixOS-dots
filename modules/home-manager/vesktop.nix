{
  lib,
  config,
  ...
}:
{
  options.vesktop-config = {
    enable = lib.mkEnableOption "enable vesktop config";
  };

  config =
    let
      cfg = config.vesktop-config;
    in
    lib.mkIf cfg.enable {
      programs.vesktop = {
        enable = true;

        settings = {
          minimizeToTray = false;
          tray = false;
          checkUpdates = false;
          hardwareAcceleration = true;
          splashTheming = true;
          splashColor = config.theme.color.foreground;
          splashBackground = config.theme.color.background;
        };

        vencord = {
          themes = {
            current = config.theme.discord.theme;
          };

          settings = {
            autoUpdate = true;
            autoUpdateNotification = true;
            notifyAboutUpdates = true;
            hardwareAcceleration = true;
            hardwareVideoAcceleration = true;
            enabledThemes = [ "current.css" ];

            plugins = {
              CallTimer.enabled = true;

              Settings = {
                enabled = true;
              };

              BetterSettings = {
                enabled = true;
                disableFade = true;
                eagerLoad = true;
                organizeMenu = true;
              };

              FriendsSince.enabled = true;
              NoDevtoolsWarning.enabled = true;
            };
          };
        };
      };
    };
}
