{
  lib,
  config,
  ...
}:
let
  cfg = config.syncthing-config;

  folders = {
    main = "${config.home.homeDirectory}/Sync";
    backgroundImgs = "${config.home.homeDirectory}/.background-images";
    school = "${config.home.homeDirectory}/Data/School-Schule";
  };
in
{
  options.syncthing-config = {
    enable = lib.mkEnableOption "enable syncthing config";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Syncthing settings, passed to services.syncthing.settings";
    };

    folders =
      let
        mkFolderOption = path: {
          enable = lib.mkEnableOption "enable folder. Located at `${path}`";
          devices = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Devices to sync with";
          };
        };
      in
      builtins.mapAttrs (_: v: (mkFolderOption v)) folders;
  };

  config = lib.mkIf config.syncthing-config.enable {
    services.syncthing = {
      enable = true;
      overrideDevices = true;
      overrideFolders = true;
      settings = lib.recursiveUpdate {
        folders = builtins.mapAttrs (
          k: v:
          lib.optionalAttrs v.enable {
            path = folders.${k};
            devices = v.devices;
          }
        ) (lib.attrsets.filterAttrs (k: v: v.enable) cfg.folders);
      } cfg.settings;
    };

    # create folder markers
    home.file = builtins.mapAttrs (
      k: v:
      lib.optionalAttrs v.enable {
        target = builtins.toPath folders.${k} + "/.stfolder";
        text = "";
      }
    ) (lib.attrsets.filterAttrs (k: v: v.enable) cfg.folders);
  };
}
