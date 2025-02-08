{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  # NOTE: This is somewhat temporary since I'm still waiting on home-manager support for zen-browser
  options.zen-config = {
    enable = lib.mkEnableOption "enable zen config";
    profile = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf config.zen-config.enable {
    home.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".default
    ];
  };
}
