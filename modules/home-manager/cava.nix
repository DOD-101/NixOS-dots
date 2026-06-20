{
  lib,
  config,
  common,
  ...
}@args:
common.mkSimpleConfigModule "cava" {
  programs.cava = {
    enable = true;
    settings = {
      general = {
        sensitivity = 70;
        bar_width = 1;
        bar_spacing = 1;
      };
      output = {
        orientation = "horizontal";
      };

      color = lib.mapAttrs (
        n: v: if (lib.strings.hasPrefix "gradient_color_" n) then "'${v}'" else v
      ) config.theme.cava.color;

      smoothing.noise_reduction = 50;
    };
  };
} args
