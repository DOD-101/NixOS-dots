{ lib, config, ... }:
{
  options = {
    wofi-config.enable = lib.mkEnableOption "enable wofi config";
  };

  config = lib.mkIf config.wofi-config.enable {
    programs.wofi = {
      enable = true;
      settings = {
        location = "top";
        y = 30;
        width = 400;
        height = 600;
        prompt = "";
        image_size = 20;
      };
      style = builtins.readFile ./wofi.css;
    };
  };
}
