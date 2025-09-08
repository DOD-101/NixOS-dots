# HACK: Use temporary version until spotify-connect feature is in release version
final: prev: {
  spotify-player = prev.spotify-player.overrideAttrs (_: rec {
    pname = "spotify-player";
    version = "77af13b48b2a03e61fef1cffea899929057551dc";
    src = prev.fetchFromGitHub {
      owner = "aome510";
      repo = "spotify-player";
      rev = version;
      hash = "sha256-hU1VVM4PfjUx6ckjwpdcrIIiInfB/B4+Dhb4dc9juaE=";
    };
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-YarKRApcQHom3AQIirqGdmUOuy5B+BRehLijvF/GRPc=";
    };
  });
}
