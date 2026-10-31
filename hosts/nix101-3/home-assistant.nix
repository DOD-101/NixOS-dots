{
  ...

}:
let
  z2mFrontendPort = 8790;
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
      homeassistant.enable = true;
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
        port = z2mFrontendPort;
        host = "0.0.0.0"; # put a reverse proxy in front if you want remote access
      };
      advanced.network_key = "GENERATE"; # generated once and stored in the data dir
    };
  };

  networking.firewall.allowedTCPPorts = [ z2mFrontendPort ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "mqtt"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
    openFirewall = true;
  };
}
