{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "quiet"
    "udev.log_priority=3"
  ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = "nix101-0"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Enable config modules
  sound-config.enable = true;
  font-config.enable = true;
  bluetooth-config.enable = true;

  # Syncthing config
  syncthing-config.enable = true;
  syncthing-config.settings = {
    devices = {
      "nix101-0" = {
        id = "E7NJQEN-MWDRATB-KKPMDJX-4YH5DCL-Y7S6PJA-F5DZE5O-YF7IWRD-QDMXJAO";
      };
      "android101-0" = {
        id = "XTGPRWO-5OPQ5JX-YC4524J-QKQ2HWH-DU5O5SR-FPKGGVU-4XDNPWT-YGZPHAC";
      };
    };

    folders = {
      "Main" = {
        path = "~/Sync";
        devices = [
          "nix101-0"
          "android101-0"
        ];
      };
      "School" = {
        path = "~/Data/School-Schule";
        devices = [
          "nix101-0"
        ];
      };
    };
  };

  users.users.david = {
    isNormalUser = true;
    home = "/home/david";
    hashedPassword = "$y$j9T$.s0C6Y6mV/Vp06fLFGN.d1$9OztuEPgV0hEwHOrOJRttqM1w0Yq2s0.4LLUXvr.dF8";
    extraGroups = [
      "wheel"
      "networkmanager"
      "openrazer"
      "plugdev"
      "input"
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "david" = import ./home.nix;
    };
    backupFileExtension = "bck";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    stow
    # openrazer-daemon
    gccgo14
    gnumake42
    go
    btop
    wirelesstools
    wl-clipboard
  ];

  # # Enable the OpenSSH daemon.
  # services.openssh = {
  #   enable = true;
  #   ports = [ 22 ];
  #   settings = {
  #     PasswordAuthentication = true;
  #     AllowUsers = [ "david" ];
  #   };
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
