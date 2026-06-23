{
  pkgs,
  config,
  inputs,
  common,
  ...
}:
let
  modules = common.enabledModules [
    "awww"
    "btop"
    "cava"
    "dev"
    "fastfetch"
    "font"
    "foot"
    "igneous-md"
    "mime"
    "mpv"
    "office"
    "spotify-player"
    "swayimg"
    "vesktop"
    "yazi"
    "zathura"
    "zen"
  ];
in
modules
// {
  home.username = "david";
  home.homeDirectory = "/home/david";

  theme.theme = "catppuccin-macchiato-mauve";

  kitty-config = {
    default = true;
    enable = true;
  };

  dod-shell-config = {
    enable = true;
    removed-components = [
      inputs.dod-shell.packages.${pkgs.stdenv.hostPlatform.system}.osk-release
    ];
    settings = {
      bar = {
        disk = "/dev/nvme0n1p1";
        show_capslock = false;
        show_numlock = true;
      };
    };
  };

  hypr-config = {
    enable = true;
    hypridle.lock_time = 3600; # 1h
    hyprland = {
      extraConfig = ''
        # Monitors

        monitorv2 {
          output = DP-4
          mode = 3440x1440@180
          position = 0x0
          scale = 1
        }

        monitorv2 {
          output = DP-6
          mode = 3440x1440@180
          position = 3440x0
          scale = 1
        }

        # Execs
        exec-once = [workspace 1 silent] ${config.term}
        exec-once = [workspace 4 silent] zen

        # Workspaces
        workspace = 1, monitor:DP-4, default:true, persistent:true
        workspace = 2, monitor:DP-4, persistent:true
        workspace = 3, monitor:DP-4, persistent:true

        workspace = 4, monitor:DP-6, default:true, persistent:true
        workspace = 5, monitor:DP-6, persistent:true
        workspace = 6, monitor:DP-6, persistent:true

        # Bindings
        bind = , XF86Tools, exec, $terminal
        bind = , XF86Launch6, exec, zen
        bind = , XF86Launch7, exec, thunderbird
        bind = , XF86Launch8, exec, gimp
        bind = , XF86Launch9, exec, keepassxc
        bind = , XF86Launch5, exec, vesktop
      '';
    };
  };

  # Syncthing config
  syncthing-config = {
    enable = true;
    folders = {
      main = {
        enable = true;
        devices = [
          "nix101-1"
          "android101-2"
        ];
      };
      school = {
        enable = true;
        devices = [
          "nix101-1"
        ];
      };
      backgroundImgs = {
        enable = true;
        devices = [
          "nix101-1"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    ckan
    drawio
    gimp
    heroic
    inkscape
    qbittorrent
    signal-desktop
    tor-browser
    unzip
    zip
  ];

  programs = {
    thunderbird.enable = true;
    keepassxc.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    };

    prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        additionalLibs = with pkgs; [
          jdk17
        ];
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
