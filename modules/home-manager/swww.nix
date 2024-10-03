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
      };
      Install = {
        WantedBy = [
          "graphical-session.target"
        ];
      };
      Service = {
        Type = "exec";
        RemainAfterExit = true;
        ExecStart = "${pkgs.writeShellScript "swww-script" ''
          #!/run/current-system/sw/bin/bash
          ${pkgs.swww}/bin/swww-daemon & disown

          ${config.swww-config.script}
        ''}";
      };
    };

  };
}
