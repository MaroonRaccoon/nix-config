{ config, pkgs, bspwmConfigPath, sxhkdConfigPath, ... }: {
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;
    layout = "us";
    windowManager.bspwm = {
      package = pkgs.bspwm;
      enable = true;
      configFile = bspwmConfigPath;
      sxhkd = {
        package = pkgs.sxhkd;
        configFile = bspwmConfigPath;
      };
    };
    displayManager = {
      startx.enable = true;
      defaultSession = "none+bspwm";
    };
    libinput.enable = true;
    videoDrivers = [ 
      "nvidia"
      "modesetting"
    ];
  };
}
