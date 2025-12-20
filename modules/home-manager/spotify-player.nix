{
  lib,
  config,
  osConfig,
  pkgs,
  inputs,
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
        inputs.spotify-player.defaultPackage.${pkgs.system}.override {
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
        cover_img_scale = config.theme.spotify-player.cover_img_scale;

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
            black = config.theme.color.black;
            red = config.theme.color.red;
            green = config.theme.color.green;
            yellow = config.theme.color.yellow;
            blue = config.theme.color.blue;
            magenta = config.theme.color.magenta;
            cyan = config.theme.color.cyan;
            white = config.theme.color.white;
          };
          component_style = {
            border = {
              fg = config.theme.spotify-player.component_style.border.fg;
            };
            selection = {
              fg = config.theme.spotify-player.component_style.selection.fg;
            };
            playback_metadata = {
              fg = config.theme.spotify-player.component_style.playback_metadata.fg;
            };
            playback_track = {
              fg = config.theme.spotify-player.component_style.playback_track.fg;
              modifiers = [ "Bold" ];
            };
            playback_album = {
              fg = config.theme.spotify-player.component_style.playback_album.fg;
              modifiers = [ "Bold" ];
            };
            playback_artists = {
              fg = config.theme.spotify-player.component_style.playback_artists.fg;
              modifiers = [ "Bold" ];
            };
            playback_progress_bar = {
              fg = config.theme.spotify-player.component_style.playback_progress_bar.fg;
            };
            playback_progress_bar_unfilled = {
              fg = config.theme.spotify-player.component_style.playback_progress_bar_unfilled.fg;
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
        Restart = "always";
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

    home.shellAliases = {
      sp = "${pkgs.writeShellScript "spotify-player" ''
        #!/run/current-system/sw/bin/bash

        if ! pgrep spotify_player > /dev/null; then 
         systemctl --user restart spotify-player-daemon.service
        fi

        spotify_player "$@"
      ''}";
    };
  };
}
