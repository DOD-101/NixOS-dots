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

      protonVpn = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Weather to install proton vpn";
      };

      tailscale = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable tailscale (client).";
      };
    };
  };

  config =
    let
      cfg = config.network-config;
    in
    lib.mkIf cfg.enable {
      networking = {
        networkmanager = {
          enable = true;
          dns = "none";
        };

        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
        ];

        hosts = {
          "0.0.0.0" = [
            "paradise-s1.battleye.com"
            "test-s1.battleye.com"
            "paradiseenhanced-s1.battleye.com"
          ];
          "192.168.178.37" = [
            "nix101-3"
          ];
        };

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

      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "client";
        extraSetFlags = [ "--accept-routes" ];
      };

      environment.systemPackages = with pkgs; [
        proton-vpn-cli
        proton-vpn
      ];
    };
}
