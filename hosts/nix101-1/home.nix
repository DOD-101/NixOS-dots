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

  theme.catppuccin-mocha.enable = true;

  btop-config = {
    enable = true;
    battery = "BAT0";
  };
  fastfetch-config.enable = true;
  foot-config.enable = true;
  igneous-config.enable = true;

  kitty-config.default = true;
  kitty-config.enable = true;
  kitty-config.enableZshIntegration = true;

  mpv-config.enable = true;
  office-config.enable = true;
  spotify-player-config.enable = true;
  swayimg-config.enable = true;
  swww-config.enable = true;
  cava-config.enable = true;
  wofi-config.enable = true;

  yazi-config.enable = true;
  yazi-config.enableZshIntegration = true;

  zathura-config.enable = true;

  zen-config.enable = true;
  zen-config.profile = "o88syg2w.default";

  zsh-config.enable = true;

  hypr-config = {
    enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      # INFO: Here we could not name zen explicitly
      extraConfig = ''
        # Monitors
        monitor=eDP-1,1920x1200,0x0,1
        monitor=HDMI-A-1,prefered, auto, 1, mirror, eDP-1

        # Execs
        exec-once = eww open SingleBarWin0
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
      plugins.hyprgrass.enable = true;
    };
  };

  eww-config = {
    enable = true;
    toggles = {
      touchscreen = true;
      show_battery = true;
      show_caps_lock = true;
      show_disk = true;
      wifi_device = "wlp2s0";
      ethernet_device = "NONE";
      cpu_temp = "ACPITZ_TEMP1";
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Dev config
  dev-config = {
    enable = true;
    git.enable = true;
    nvim.enable = true;
  };

  home.packages = with pkgs; [
    firefox
    keepassxc
    signal-desktop

    # discord
    vesktop

    # email
    thunderbird

    # minecraft
    prismlauncher
    jdk17

    # art
    gimp
    inkscape

    # blender
    drawio
  ];

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
