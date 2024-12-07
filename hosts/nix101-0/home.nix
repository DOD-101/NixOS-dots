{
  pkgs,
  inputs,
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

  theme.ocean-breeze.enable = true;

  zsh-config.enable = true;
  foot-config.enable = true;
  fastfetch-config.enable = true;
  wofi-config.enable = true;
  spotify-player-config.enable = true;
  vis-config.enable = true;
  mpv-config.enable = true;
  swww-config.enable = true;
  zathura-config.enable = true;

  eww-config.enable = true;

  kitty-config.enable = true;
  kitty-config.default = true;
  kitty-config.enableZshIntegration = true;

  yazi-config.enable = true;
  yazi-config.enableZshIntegration = true;

  office-config.enable = true;

  hypr-config = {
    enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      extraConfig = ''
        # Monitors
        monitor=DP-4,3440x1440,0x0,1
        monitor=DP-6,3440x1440,3440x0,1

        # Execs
        exec-once = eww open-many BarWin0 BarWin1
        exec-once = [workspace 1 silent] ${config.term}
        exec-once = [workspace 2 silent] zen

        # Workspaces
        workspace = 1, monitor:DP-4, default:true, persistent:true
        workspace = 2, monitor:DP-6, default:true, persistent:true
        workspace = 3, monitor:DP-4, persistent:true
        workspace = 4, monitor:DP-6, persistent:true
        workspace = 5, monitor:DP-4, persistent:true
        workspace = 6, monitor:DP-6, persistent:true
      '';
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

  home.packages =
    with pkgs;
    [
      firefox
      webkitgtk_4_1
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
    ]
    ++ [
      inputs.zen-browser.packages."${system}".default
    ];

  home.activation.createSyncDir = {
    before = [ "writeBoundary" ]; # Optional, but recommended
    after = [ "writeGlobalProfile" ]; # Optional, but recommended
    data = "mkdir -p ~/Sync/.stfolder";
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
