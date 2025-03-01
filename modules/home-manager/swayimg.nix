{
  config,
  lib,
  ...
}:
{
  options.swayimg-config = {
    enable = lib.mkEnableOption "enable swayimg config";
  };

  config = lib.mkIf config.swayimg-config.enable {
    programs.swayimg = {
      enable = true;
      settings = {
        "keys.viewer" = {
          "Shift+question" = "help";
          "h" = "step_left 10";
          "j" = "step_down 10";
          "k" = "step_up 10";
          "l" = "step_right 10";
          "Escape" = "mode";
          "Shift+h" = "rotate_left";
          "Shift+k" = "next_file";
          "Shift+j" = "prev_file";
          "Shift+l" = "rotate_right";
          "Shift+equal" = "zoom fill";
        };
        "keys.gallery" = {
          "Shift+question" = "help";
          "Escape" = "mode";
          "h" = "step_left";
          "j" = "step_down";
          "k" = "step_up";
          "l" = "step_right";
        };
        viewer = {
          preload = 1;
          history = 1;
        };
      };
    };
  };
}
