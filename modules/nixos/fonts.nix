{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    font-config.enable = lib.mkEnableOption "enable font config";
  };

  config = lib.mkIf config.font-config.enable {
    fonts.enableDefaultPackages = true;
    environment.systemPackages = with pkgs; [
      fontconfig
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      corefonts
    ];
  };
}
