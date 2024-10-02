{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    mpv-config.enable = lib.mkEnableOption "enable mpv config";
  };

  config = lib.mkIf config.mpv-config.enable {
    programs.mpv = {
      enable = true;
      bindings = {
        space = "cycle pause; script-binding uosc/flash-pause-indicator";
        l = "no-osd seek  5; script-binding uosc/flash-timeline";
        h = "no-osd seek -5; script-binding uosc/flash-timeline";
        k = "no-osd add volume  10; script-binding uosc/flash-volume";
        j = "no-osd add volume -10; script-binding uosc/flash-volume";
        "+" = "no-osd add volume  10; script-binding uosc/flash-volume";
        "-" = "no-osd add volume -10; script-binding uosc/flash-volume";
        m = "no-osd cycle mute; script-binding uosc/flash-volume";
        "shift+right" = "no-osd seek  30; script-binding uosc/flash-timeline";
        "shift+left" = "no-osd seek -30; script-binding uosc/flash-timeline";
        "[" = "no-osd add speed -0.25; script-binding uosc/flash-speed";
        "]" = "no-osd add speed  0.25; script-binding uosc/flash-speed";
        "\\" = "no-osd set speed 1; script-binding uosc/flash-speed";
        ">" = "script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline";
        "<" = "script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline";
        wheel_up = "no-osd add volume  1; script-binding uosc/flash-volume";
        wheel_down = "no-osd add volume  -1; script-binding uosc/flash-volume";
      };

      config = {
        keep-open = true;
      };

      scripts = [ pkgs.mpvScripts.uosc ];
      scriptOpts = {
        uosc = {
          volume_size = 30;
          top_bar_controls = true;
          languages = "slang,en,de";
          color = "foreground=${config.theme.hashlessColor.yellow},foreground_text=${config.theme.hashlessColor.foreground},background=${config.theme.hashlessColor.background},background_text=${config.theme.hashlessColor.foreground},curtain=111111,success=a5e075,error=ff616e";
        };
      };
    };
  };
}
