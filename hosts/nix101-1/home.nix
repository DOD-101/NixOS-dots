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
  btop-config.enable = true;
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
      # INFO: Here we could not name zen explicitly
      extraConfig = ''
        # Monitors
        monitor=eDP-1,1920x1200,0x0,1

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
      plugins.hyprgrass.enable = true;
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

  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    colorSchemes = {
      current_theme = {
        ansi = [
          config.theme.color.black
          config.theme.color.red
          config.theme.color.green
          config.theme.color.yellow
          config.theme.color.blue
          config.theme.color.magenta
          config.theme.color.cyan
          config.theme.color.white
        ];
        brights = [
          config.theme.color.bright.black
          config.theme.color.bright.red
          config.theme.color.bright.green
          config.theme.color.bright.yellow
          config.theme.color.bright.blue
          config.theme.color.bright.magenta
          config.theme.color.bright.cyan
          config.theme.color.bright.white
        ];
        background = config.theme.color.background;
        foreground = config.theme.color.foreground;
        cursor_bg = "#BEAF8A";
        cursor_border = "#BEAF8A";
        cursor_fg = "#1B1B1B";
        selection_bg = "#444444";
        selection_fg = "#E9E9E9";
      };
    };

    extraConfig = builtins.readFile ../../resources/wezterm/wezterm.lua;
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

      # art
      gimp
      inkscape

      # blender
      drawio
    ]
    ++ [
      inputs.zen-browser.packages."${system}".default
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
