{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    nvidia-config.enable = lib.mkEnableOption "enable nvidia config";
  };

  config = lib.mkIf config.nvidia-config.enable {
    hardware.graphics = {
      enable = true;
    };

    home.packages = with pkgs; [

      cudatoolkit
    ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "560.35.03";

      sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
      sha256_aarch64 = lib.fakeSha256;
      openSha256 = lib.fakeSha256;
      settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
      persistencedSha256 = lib.fakeSha256;
    };
  };
}
