{
  config,
  osConfig,
  pkgs,
  inputs,
  common,
  ...
}@args:
common.mkSimpleConfigModule "spotify-player" {
  programs.spotify-player = {
    enable = true;
    package = (
      inputs.spotify-player.defaultPackage.${pkgs.stdenv.hostPlatform.system}.override {
        withNotify = false;
      }
    );

    settings = {
      theme = "main";
      client_id = "d420a117a32841c2b3474932e49fb54b";
      playback_format = "{track} • {album} • {artists}\n{genres}\n\n\n{metadata}";
      tracks_playback_limit = 50;
      app_refresh_duration_in_ms = 32;
      page_size_in_rows = 20;
      play_icon = "";
      pause_icon = "󰏥";
      liked_icon = "󰣐";
      genre_num = 2;
      border_type = "Rounded";
      progress_bar_type = "Line";
      enable_media_control = true;
      enable_streaming = "Never";
      enable_cover_image_cache = true;
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
      (
        {
          name = "main";
        }
        // config.theme.spotify-player.theme
      )
    ];
  };

  # daemon config
  xdg.configFile = {
    "spotify-player/daemon/app.toml" = {
      source = (pkgs.formats.toml { }).generate "spotify-player-daemon-config" {
        client_id = "d420a117a32841c2b3474932e49fb54b";
        tracks_playback_limit = 50;
        enable_media_control = true;
        enable_streaming = "Always";
        device = {
          name = "${osConfig.networking.hostName}-daemon";
          device_type = "computer";
          volume = 80;
          bitrate = 320;
          audio_cache = true;
          normalization = false;
          autoplay = true;
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
      Restart = "always";
      ExecStart = "${config.programs.spotify-player.package}/bin/spotify_player -d -c ${config.home.homeDirectory}/.config/spotify-player/daemon/";
    };
  };

  home.shellAliases.sp = "spotify_player";
} args
