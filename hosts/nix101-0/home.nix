{
  pkgs,
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
