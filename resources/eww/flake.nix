{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    topiary.url = "github:tweag/topiary";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {

      packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = [
          inputs.topiary.packages.x86_64-linux.topiary-cli
        ];
        TOPIARY_CONFIG_FILE = "/home/david/Data/Coding-Adventures/Rust-Crabs/yuckier-topiary/topiary/languages.ncl";
        TOPIARY_LANGUAGE_DIR = "/home/david/Data/Coding-Adventures/Rust-Crabs/yuckier-topiary/topiary/topiary-queries/queries/";
      };

    };
}
