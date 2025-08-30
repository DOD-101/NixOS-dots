{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.swww-config = {
    enable = lib.mkEnableOption "enable swww config";
    script = lib.mkOption {
      type = lib.types.str;
      description = "Script to run after initializing the daemon.";
    };
  };

  config = lib.mkIf config.swww-config.enable {
    home.packages = with pkgs; [
      swww
    ];

    systemd.user.services.swww = {
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
        ExecStart = "${pkgs.writeShellScript "swww-script" ''
          ${pkgs.swww}/bin/swww-daemon & 

          ${config.swww-config.script}
        ''}";
      };
    };

  };
}
