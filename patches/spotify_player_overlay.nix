# HACK: Use temporary version until spotify-connect feature is in release version
final: prev: {
  spotify-player = prev.spotify-player.overrideAttrs (_: rec {
    pname = "spotify-player";
    version = "bd38dd05a3c52107f76665dc88002e5a0815d095";
    src = prev.fetchFromGitHub {
      owner = "aome510";
      repo = "spotify-player";
      rev = version;
      hash = "sha256-DCIZHAfI3x9I6j2f44cDcXbMpZbNXJ62S+W19IY6Qus=";
    };
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-fNDztl0Vxq2fUzc6uLNu5iggNRnRB2VxzWm+AlSaoU0=";
    };
  });
}
