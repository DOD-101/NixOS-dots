{
  config,
  pkgs,
  ...
}:
let
  v = import ./vars.nix;
in
{
  # 1. MQTT broker
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "127.0.0.1";
        port = 1883;
        # Localhost-only and unauthenticated for simplicity.
        # For real auth, see the note below.
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
        acl = [ "topic readwrite #" ];
      }
    ];
  };

  # 2. Zigbee2MQTT
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant.enabled = true;
      mqtt = {
        server = "mqtt://127.0.0.1:1883";
        base_topic = "zigbee2mqtt";
      };
      serial = {
        port = "tcp://192.168.178.40:6638";
        adapter = "zstack";
        baudrate = 115200;
      };
      frontend = {
        enabled = true;
        port = v.z2mFrontendPort;
        host = "0.0.0.0"; # put a reverse proxy in front if you want remote access
      };
      advanced.network_key = "!${config.sops.templates."z2m-secrets.yaml".path} network_key";
    };
  };

  networking.firewall.allowedTCPPorts = [
    v.z2mFrontendPort
    v.haFrontendPort
  ];

  services.home-assistant = {
    enable = true;
    customComponents = with pkgs.home-assistant-custom-components; [
      scene_presets
    ];
    extraComponents = [
      "mqtt"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
  };

  # HACK: We have to do this to allow ha to use the reverse-proxy, but there is
  # not proper way to configure this declaratively
  systemd.services.home-assistant.preStart =
    let
      http = {
        version = 2;
        minor_version = 2;
        key = "http";
        data = {
          pending = null;
          stable = {
            cors_allowed_origins = [ "https://cast.home-assistant.io" ];
            created_at = "2026-11-12T20:18:10.646009+00:00";
            error = null;
            error_message = null;
            ip_ban_enabled = true;
            login_attempts_threshold = -1;
            server_host = [
              "0.0.0.0"
              "::"
            ];
            server_port = v.haFrontendPort;
            ssl_profile = "modern";
            use_x_forwarded_for = true;
            # the options we care about for the proxy
            use_x_frame_options = true;
            trusted_proxies = [
              "127.0.0.1"
              "::1"
            ];
          };
          yaml_migration_done = true;
        };
      };

      httpFile = builtins.toFile "http" (builtins.toJSON http);
    in
    ''
      p="/var/lib/hass/.storage/"
      ${pkgs.coreutils}/bin/install -D -m 0600 ${httpFile} "$p/http"
    '';
}
