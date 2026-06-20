{
  pkgs,
  config,
  common,
  ...
}:
let
  modules = common.enabledModules [
    "awww"
    "cava"
    "dev"
    "fastfetch"
    "font"
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

  theme.theme = "catppuccin-frappe-peach";

  btop-config = {
    enable = true;
    battery = "BAT0";
  };

  kitty-config = {
    enable = true;
    default = true;
  };

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
    hyprland = {
      # INFO: Here we could not name zen explicitly
      extraConfig = ''
        # Monitors
        monitor=eDP-1,1920x1200,0x0,1
        monitor=HDMI-A-1,preferred, auto, 1

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

      plugins.hyprgrass.enable = true;
    };
  };

  syncthing-config = {
    enable = true;
    folders = {
      main = {
        enable = true;
        devices = [
          "nix101-0"
          "android101-2"
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

  programs = {
    thunderbird.enable = true;
    keepassxc.enable = true;

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

  home.packages = with pkgs; [
    drawio
    gimp
    signal-desktop
    unzip
    zip
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
