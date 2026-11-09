{
  pkgs,
  ...
}:
{
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/var/secrets/cache-priv-key.pem";
    port = 5000;
    openFirewall = true;
  };
}
