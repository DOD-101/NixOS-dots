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

    environment.systemPackages = with pkgs; [
      cudatoolkit
    ];

    environment.variables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      WEBKIT_DISABLE_DMABUF_RENDERER = "1";
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia-container-toolkit.enable = true;

    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.142";

      sha256_64bit = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM=";
      sha256_aarch64 = lib.fakeSha256;
      openSha256 = lib.fakeSha256;
      settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
      persistencedSha256 = lib.fakeSha256;
    };
  };
}
