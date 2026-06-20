{ inputs, ... }:
{
  imports = [
    inputs.dod-shell.homeManagerModules.default
    ./awww.nix
    ./btop.nix
    ./cava.nix
    ./cursor.nix
    ./dod-shell.nix
    ./fastfetch.nix
    ./fonts.nix
    ./hypr.nix
    ./igneous-md.nix
    ./mime.nix
    ./mpv.nix
    ./office.nix
    ./spotify-player.nix
    ./swayimg.nix
    ./syncthing.nix
    ./vesktop.nix
    ./yazi.nix
    ./zathura.nix
    ./zen.nix

    ./dev.nix
    ./shell
    ./term
  ];
}
