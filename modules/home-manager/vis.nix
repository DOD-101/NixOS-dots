{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    vis-config.enable = lib.mkEnableOption "enable vis config";
  };

  config = lib.mkIf config.vis-config.enable {
    home.packages = with pkgs; [
      cli-visualizer
    ];

    home.file.".config/vis/config".text = ''
      visualizer.fps=60
      colors.scheme=${config.theme.vis.defaultColorScheme}
      #Available smoothing options are monstercat, sgs, none.
      visualizer.spectrum.smoothing.mode=sgs
      visualizer.spectrum.smoothing.factor=2
      visualizer.spectrum.bar.width=1
      visualizer.spectrum.bar.spacing=1
      visualizer.scaling.multiplier=0.5

      #Configures how fast the falloff character falls. This is an exponential falloff so values usually look
      #best 0.9+ and small changes in this value can have a large effect. Defaults to 0.95
      visualizer.spectrum.falloff.weight=1.2

      #Configures the samples rate and the cutoff frequencies.
      audio.sampling.frequency=88200
      audio.low.cutoff.frequency=60
      audio.high.cutoff.frequency=22050
    '';

  };
}
