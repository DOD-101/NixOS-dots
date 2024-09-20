{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
{

  options.spotify-player-config = {
    enable = lib.mkEnableOption "enable spotify player config";
  };

  config = lib.mkIf config.spotify-player-config.enable {
    programs.spotify-player = {
      enable = true;
      package = (
        pkgs.spotify-player.override {
          withNotify = false;
        }
      );

      settings = {
        theme = "main";
        client_id = "fb9c6f0fd604439e8a6ac868290354c3";
        client_port = 8080;
        playback_format = "{track} • {album} • {artists}\n\n\n\n{metadata}";
        tracks_playback_limit = 500;
        app_refresh_duration_in_ms = 32;
        page_size_in_rows = 20;
        play_icon = "";
        pause_icon = "󰏥";
        liked_icon = "󰣐";
        border_type = "Rounded";
        progress_bar_type = "Line";
        enable_media_control = true;
        enable_streaming = "Never";
        enable_cover_image_cache = true;
        default_device = "${osConfig.networking.hostName}-daemon";
        cover_img_scale = 2.2;

        copy_command = {
          command = "wl-copy";
          args = [ ];
        };

        layout = {
          library = {
            album_percent = 40;
            playlist_percent = 40;
          };
          playback_window_height = 6;
          playback_window_position = "Top";
        };
      };

      themes = [
        {
          name = "main";
          palette = {
            black = "#000000";
            red = "#ff1616";
            green = "#7cd605";
            yellow = "#feb301";
            blue = "#3073d9";
            magenta = "#d135de";
            cyan = "#13dd7e";
            white = "#fef2d0";
          };
          component_style = {
            selection = {
              fg = "Yellow";
            };
            playback_metadata = {
              fg = "Blue";
            };
            playback_track = {
              fg = "White";
              modifiers = [ "Bold" ];
            };
            playback_album = {
              fg = "White";
              modifiers = [ "Bold" ];
            };
            playback_artists = {
              fg = "White";
              modifiers = [ "Bold" ];
            };
            playback_progress_bar = {
              fg = "Green";
            };
            playback_progress_bar_unfilled = {
              fg = "Red";
            };
          };
        }
      ];
    };

    # daemon config
    xdg.configFile = {
      "spotify-player/daemon/app.toml" = {
        source = (pkgs.formats.toml { }).generate "spotify-player-daemon-app" {
          client_id = "fb9c6f0fd604439e8a6ac868290354c3";
          client_port = 8080;
          tracks_playback_limit = 500;
          enable_media_control = true;
          enable_streaming = "Always";
          device = {
            name = "${osConfig.networking.hostName}-daemon";
            device_type = "speaker";
            volume = 70;
            bitrate = 320;
            audio_cache = true;
            normalization = false;
          };
        };
      };
    };

    systemd.user.services.spotify-player-daemon = {
      Unit = {
        Description = "Spotify Player Daemon";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "exec";
        RemainAfterExit = true;
        ExecStart = "${config.programs.spotify-player.package}/bin/spotify_player -d -c ${config.home.homeDirectory}/.config/spotify-player/daemon/";
      };
    };
  };
}
