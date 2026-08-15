{
  common,
  ...
}@args:
common.mkSimpleConfigModule "swayimg" {
  programs.swayimg = {
    enable = true;
    initLua = ../../resources/swayimg/init.lua;
  };
} args
