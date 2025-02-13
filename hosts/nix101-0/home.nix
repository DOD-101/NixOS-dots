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

  theme.catppuccin-mocha.enable = true;

  btop-config.enable = true;
  fastfetch-config.enable = true;
  foot-config.enable = true;

  kitty-config.default = true;
  kitty-config.enable = true;
  kitty-config.enableZshIntegration = true;

  mpv-config.enable = true;
  office-config.enable = true;
  spotify-player-config.enable = true;
  swww-config.enable = true;
  vis-config.enable = true;
  wofi-config.enable = true;

  yazi-config.enable = true;
  yazi-config.enableZshIntegration = true;

  zathura-config.enable = true;

  zen-config.enable = true;
  zen-config.profile = "1kiwrwon.default";

  zsh-config.enable = true;

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

  eww-config = {
    enable = true;
    toggles = {
      show_caps_lock = true;
      show_num_lock = true;
      show_disk = true;
      wifi_device = "wlp12s0";
      ethernet_device = "enp59s0";
      cpu_temp = "K10TEMP_TCCD2";
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
      keepassxc
      signal-desktop

      # discord
      vesktop

      # email
      thunderbird

      # minecraft
      prismlauncher
      jdk17

      ckan

      # art
      gimp
      inkscape
      # blender
      drawio
    ]
    ++ [
      inputs.igneous-md.packages."${system}".igneous-md-release
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
