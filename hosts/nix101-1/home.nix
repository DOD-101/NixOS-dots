{
  pkgs,
  config,
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

  theme.theme = "catppuccin-frappe-peach";

  btop-config = {
    enable = true;
    battery = "BAT0";
  };
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
    settings = {
      bar = {
        disk = "/dev/nvme0n1p1";
        battery = "BAT0";
        show_capslock = false;
        show_numlock = false;
        show_osk_button = true;
      };
    };
  };

  hypr-config = {
    enable = true;
    hypridle.enable = true;
    hyprlock = {
      enable = true;
    };
    hyprland = {
      enable = true;
      # INFO: Here we could not name zen explicitly
      extraConfig = ''
        # Monitors
        monitor=eDP-1,1920x1200,0x0,1
        monitor=HDMI-A-1,preferred, auto, 1, mirror, eDP-1

        # Execs
        exec-once = [workspace 1 silent] ${config.term}
        exec-once = [workspace 2 silent] zen

        # Workspaces
        workspace = 1, monitor:eDP-1, default:true, persistent:true
        workspace = 2, monitor:eDP-1, persistent:true
        workspace = 3, monitor:eDP-1, persistent:true

        device {
          name=elan06fa:00-04f3:31ad-touchpad
          enabled=$touchpadEnabled
        }
      '';

      # WARN: Hyprgrass is broken, change this back once it is fixed
      plugins.hyprgrass.enable = false;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  gtk.gtk4.theme = null;

  syncthing-config = {
    enable = true;
    settings = {
      devices = {
        "nix101-0" = {
          id = "E7NJQEN-MWDRATB-KKPMDJX-4YH5DCL-Y7S6PJA-F5DZE5O-YF7IWRD-QDMXJAO";
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
          "nix101-0"
          "android101-0"
        ];
      };
      school = {
        enable = true;
        devices = [
          "nix101-0"
        ];
      };
      backgroundImgs = {
        enable = true;
        devices = [
          "nix101-0"
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

    # email
    thunderbird

    # art
    gimp
    inkscape

    # blender
    drawio
  ];

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
