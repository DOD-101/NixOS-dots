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
    environment.systemPackages = with pkgs; [
      fontconfig
    ];

    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];
  };
}
