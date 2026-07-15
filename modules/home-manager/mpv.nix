{
  pkgs,
  config,
  common,
  ...
}@args:
common.mkSimpleConfigModule "mpv" {
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
      right = "no-osd seek  10; script-binding uosc/flash-timeline";
      left = "no-osd seek -10; script-binding uosc/flash-timeline";
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
      osd-bar = false;
    };

    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
      mpris
    ];
    scriptOpts = {
      uosc = {
        volume_size = 30;
        top_bar_controls = false;
        languages = "slang,en,de";
        color =
          let
            col = config.theme.hashlessColor;
          in
          "foreground=${col.yellow},foreground_text=${col.foreground},background=${col.background},background_text=${col.foreground},curtain=111111,success=a5e075,error=ff616e";
      };
    };
  };
} args
