{ ... }:
{
  nixpkgs.overlays = [
    (import ./spotify_player_overlay.nix)
  ];
}
