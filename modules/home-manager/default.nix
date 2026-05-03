{ inputs, ... }:
{
  imports = [
    inputs.dod-shell.homeManagerModules.default
    ./btop.nix
    ./cava.nix
    ./cursor.nix
    ./dev.nix
    ./dev.nix
    ./dod-shell.nix
    ./fastfetch.nix
    ./hypr.nix
    ./igneous-md.nix
    ./mime.nix
    ./mpv.nix
    ./office.nix
    ./shell
    ./spotify-player.nix
    ./swayimg.nix
    ./awww.nix
    ./syncthing.nix
    ./term
    ./vesktop.nix
    ./yazi.nix
    ./zathura.nix
    ./zen.nix
  ];
}
