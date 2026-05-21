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
    fonts = {
      enableDefaultPackages = true;
      antialiasing = true;
      subpixelRendering = "rgb";
      defaultFonts = {
        inherit (config.theme.fonts) monospace sansSerif serif;
        emoji = [ "NotoColorEmoji" ];
      };

      packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.recursive-mono
        noto-fonts-color-emoji
        corefonts
      ];
    };
  };
}
