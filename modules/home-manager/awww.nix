{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.awww-config = {
    enable = lib.mkEnableOption "enable awww config";
    script = lib.mkOption {
      type = lib.types.str;
      default = config.theme.awww.script;
      description = "Script to run after initializing the daemon.";
    };
  };

  config = lib.mkIf config.awww-config.enable {
    home.packages = with pkgs; [
      awww
    ];

    systemd.user.services.awww = {
      Unit = {
        Description = "Swww wallpaper service.";

        After = [ "hyprland-session.target" ];
        BindsTo = [ "hyprland-session.target" ];
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
      Service = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = 3;
        RemainAfterExit = true;
        ExecStart = "${pkgs.writeShellScript "awww-script" ''
          ${pkgs.awww}/bin/awww-daemon &

          ${config.awww-config.script}
        ''}";
      };
    };

  };
}
