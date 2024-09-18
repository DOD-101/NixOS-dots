{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:heywoodlh/flakes/main?dir=zen-browser";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations.nix101-0 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/nix101-0/configuration.nix
          ./modules/nixos/nvidia.nix
          ./modules/nixos/bluetooth.nix
          ./modules/nixos/sound.nix
          ./modules/nixos/razer.nix
          ./modules/nixos/fonts.nix
          ./modules/nixos/syncthing.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
