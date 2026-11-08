{
  pkgs,
  common,
  ...
}@args:
common.mkSimpleConfigModule "nvidia" {
  hardware.graphics = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    cudatoolkit
  ];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia = {
    open = false;
    branch = "latest";
    modesetting.enable = true;
  };
} args
