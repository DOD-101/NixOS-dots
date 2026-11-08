{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-preview-share-picker = {
      url = "git+https://github.com/WhySoBad/hyprland-preview-share-picker?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    igneous-md = {
      url = "github:DOD-101/igneous-md/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dod-shell = {
      url = "github:DOD-101/dod-shell/";
      # url = "/home/david/Data/Coding-Adventures/Rust-Crabs/dod-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotify-player = {
      url = "github:aome510/spotify-player";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    commit-lsp = {
      url = "github:dod-101/commit-lsp/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # catppuccin inputs
    catppuccin-zen = {
      # HACK: temp until https://github.com/catppuccin/zen-browser/pull/75
      url = "github:gkze/zen-browser/fix/frappe-zen-twilight-acrylic-gap";
      # url = "github:catppuccin/zen-browser";
      flake = false;
    };

    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };

    catppuccin-discord = {
      url = "github:catppuccin/discord";
      flake = false;
    };

    catppuccin-fish = {
      url = "github:catppuccin/fish";
      flake = false;
    };

    catppuccin-vimium = {
      url = "github:catppuccin/vimium";
      flake = false;
    };

    catppuccin-yazi = {
      url = "github:catppuccin/yazi";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nur,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      common = (import ./common.nix { lib = nixpkgs.lib; });
      palettes = {
        catppuccin = import ./resources/palettes/catppuccin.nix;
      };

      # HACK: until PRs are merged / in unstable
      patchedNixpkgs =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.applyPatches {
          name = "nixpkgs-config-store-1.0.1";
          src = nixpkgs;
          patches = [
            (pkgs.fetchpatch {
              url = "https://github.com/NixOS/nixpkgs/pull/585070.patch";
              hash = "sha256-LFYO7q8Kj/ZRh/L+2WyI1NYmZ2carktRx34ytZLeeVg=";
            })
            (pkgs.fetchpatch {
              url = "https://github.com/NixOS/nixpkgs/pull/584290.patch";
              hash = "sha256-66Ybt81Sx12ZCKwtqKqrYvpVN3c3ejubsR4XR5CEfpU=";
            })
            (pkgs.fetchpatch {
              url = "https://github.com/NixOS/nixpkgs/pull/584283.patch";
              hash = "sha256-+qQ3o+aJenYyO0BFNt4+Fhqsh2uU9eClgCdZOXwKSGg=";
            })
          ];
        };

      patchedPkgs = import patchedNixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      mkSystem =
        {
          host,
          mainUser ? "david",
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              palettes
              common
              patchedPkgs
              ;
          };

          modules = [
            home-manager.nixosModules.default
            sops-nix.nixosModules.sops
            {
              nixpkgs.overlays = [ nur.overlays.default ];
            }
            ./hosts/${host}/configuration.nix
            ./modules/nixos
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit
                    inputs
                    palettes
                    common
                    patchedPkgs
                    ;
                };
                sharedModules = [
                  ./modules/home-manager
                  ./themes
                ];
                backupFileExtension = "bck";
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${mainUser} = import ./hosts/${host}/home.nix;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nix101-0 = mkSystem { host = "nix101-0"; };
        nix101-1 = mkSystem { host = "nix101-1"; };
        nix101-2 = mkSystem {
          host = "nix101-2";
          mainUser = "server";
        };
        nix101-3 = mkSystem {
          host = "nix101-3";
          mainUser = "server";
        };
      };
    };

}
