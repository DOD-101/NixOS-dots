{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    network-config = {
      enable = lib.mkEnableOption "enable network config";

      hostName = lib.mkOption {
        type = lib.types.str;
        description = "passed to networking.hostName";
      };

      protonVpn = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Weather to install proton vpn";

      };
    };
  };

  config =
    let
      cfg = config.network-config;
    in
    lib.mkIf cfg.enable {
      networking = {
        hostName = cfg.hostName;
        networkmanager = {
          enable = true;
          dns = "none";
        };

        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
        ];

        firewall = {
          allowedTCPPortRanges = [
            {
              from = 8000;
              to = 8500;
            }
          ];
          allowedUDPPortRanges = [
            {
              from = 8000;
              to = 8500;
            }
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        proton-vpn-cli
        protonvpn-gui
      ];

    };

}
