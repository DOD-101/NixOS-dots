{ lib, config, ... }:
{
  options = {
    syncthing-config.enable = lib.mkEnableOption "enable syncthing config";
    syncthing-config.settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Syncthing settings, passed to services.syncthing.settings";
    };
  };

  config = lib.mkIf config.syncthing-config.enable {
    services.syncthing = {
      enable = true;
      user = "david";
      dataDir = "/home/david/Data";
      overrideDevices = true;
      overrideFolders = true;
      settings = config.syncthing-config.settings;
    };
  };
}
