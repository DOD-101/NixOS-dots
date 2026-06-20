{
  config,
  common,
  ...
}@args:
# If vesktop breaks:
#
# ```js
# await Vencord.Updater.checkForUpdates()
# await Vencord.Updater.update()
# VesktopNative.app.relaunch()
# ```
common.mkSimpleConfigModule "vesktop" {
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
        videoHardwareAcceleration = true;
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
          customIdle = {
            enable = true;
            idleTimeout = 0;
            remainInIdle = true;
          };
        };
      };
    };
  };
} args
