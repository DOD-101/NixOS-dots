{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.borg-config = {
    enable = lib.mkEnableOption "enable borg config";
    mountLocation = lib.mkOption {
      type = lib.types.str;
      default = "/run/media/david/Backup0/";
      description = "The Mount location. After this comes the dir with the backup.";
    };
  };

  config = lib.mkIf config.borg-config.enable {
    services.borgbackup.jobs = {
      # for a local backup
      homeBackup = {
        paths = "/home";
        exclude = [
          "/home/*/.cache"
          "/home/*/.config/vesktop/sessionData"
          "/home/*/.cargo"
          "/home/*/.local/share/Steam"
          "/home/*/Data/**/target"
        ];
        repo = "${config.borg-config.mountLocation}/${config.networking.hostName}-Backup";
        encryption = {
          mode = "none";
        };
        prune.keep = {
          within = "1d"; # Keep all archives from the last day
          daily = 7;
          weekly = 4;
          monthly = -1; # Keep at least one archive for each month
        };
        compression = "auto,lzma";
        startAt = [ ];
      };
    };

  };

}
