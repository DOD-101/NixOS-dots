{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
    ../../themes
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "david";
  home.homeDirectory = "/home/david";

  theme.theme = "catppuccin-macchiato-mauve";

  btop-config.enable = true;
  fastfetch-config.enable = true;
  foot-config.enable = true;
  igneous-config.enable = true;

  kitty-config.default = true;
  kitty-config.enable = true;

  mime-config.enable = true;
  mpv-config.enable = true;
  office-config.enable = true;
  spotify-player-config.enable = true;
  swayimg-config.enable = true;
  swww-config.enable = true;
  cava-config.enable = true;

  yazi-config.enable = true;

  vesktop-config.enable = true;

  zathura-config.enable = true;

  zen-config.enable = true;

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

  programs.opencode.enable = true;

  hypr-config = {
    enable = true;
    hypridle = {
      enable = true;
      lock_time = 3600; # 1h
    };
    hyprlock.enable = true;
    hyprland = {
      enable = true;
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

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  gtk.gtk4.theme = null;

  # Syncthing config
  syncthing-config = {
    enable = true;
    settings = {
      devices = {
        "nix101-1" = {
          id = "YWZ23VE-MJZEY2A-3WLNHNX-IP4EJO7-ZYTDVUD-JQBPP3Q-ZKMIQ6R-RP7FFQJ";
        };
        "android101-0" = {
          id = "XTGPRWO-5OPQ5JX-YC4524J-QKQ2HWH-DU5O5SR-FPKGGVU-4XDNPWT-YGZPHAC";
        };
      };
    };

    folders = {
      main = {
        enable = true;
        devices = [
          "nix101-1"
          "android101-0"
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

  # Dev config
  dev-config = {
    enable = true;
    git.enable = true;
    nvim.enable = true;
  };

  home.packages = with pkgs; [
    keepassxc
    signal-desktop

    tor-browser
    qbittorrent

    # email
    thunderbird

    ckan
    heroic

    # art
    gimp
    inkscape
    # blender
    drawio
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      additionalLibs = with pkgs; [
        jdk17
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
