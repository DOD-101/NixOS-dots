{
  lib,
  config,
  osConfig,
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
      cert = osConfig.sops.secrets.syncthing_cert.path;
      key = osConfig.sops.secrets.syncthing_key.path;
      settings = lib.recursiveUpdate {
        folders = builtins.mapAttrs (
          k: v:
          lib.optionalAttrs v.enable {
            path = folders.${k};
            devices = v.devices;
          }
        ) (lib.attrsets.filterAttrs (k: v: v.enable) cfg.folders);
        devices = lib.filterAttrs (k: _: k != osConfig.networking.hostName) {
          "nix101-0".id = "LC766C6-2Y2VVNG-AUDHDYN-AVXENF6-7ANCOXZ-QPSJM5H-CB6SLP2-YM7CKAE";
          "nix101-1".id = "I4N7SM3-CJRDFQB-44ETP7M-P3RLANS-DDZJSHJ-JEPEDUR-EEAU3LO-RMOTWAB";
          "android101-0".id = "XTGPRWO-5OPQ5JX-YC4524J-QKQ2HWH-DU5O5SR-FPKGGVU-4XDNPWT-YGZPHAC"; # non-declarative
        };
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
