user: { alacrittyConfigPath, bspwmConfigPath, sxhkdConfigPath, bashrcPath, ... }: { pkgs, ... }: {
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "22.11";
    file = {
      ".xinitrc".text = import ./dotfiles/xinitrc.nix { 
        wm-command = ''
          sxhkd -c ${sxhkdConfigPath} &
          exec bspwm -c ${bspwmConfigPath}
        '';
      };
      ".alacritty.yml".source = alacrittyConfigPath;
      ".bashrc".source = bashrcPath;
    };
  };
  programs.git = {
    enable = true;
    userName = "Mapa Raccoon";
    userEmail = "maparaccoon@gmail.com";
    package = pkgs.gitFull;
    extraConfig = {
      credential.helper = "store";
    };
  };
  services.picom = {
    enable = true;
    inactiveOpacity = 0.8;
    activeOpacity = 0.9; #"0.90";
    opacityRules = [ "100:class_g = 'Google-chrome'" "100:class_g = 'Alacritty'" "60:class_g = 'rofi'" ];
    fade = true;
    vSync = true;
    shadow = true;
    fadeDelta = 4;
    #fadeSteps = [0.02 0.02];
    backend = "glx";
  };
}
