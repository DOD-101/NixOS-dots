{
  ...

}:
{
  services.home-assitant = {
    enable = true;
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
    openFirewall = true;
  };
}
