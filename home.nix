user: { alacrittyConfigPath, bspwmConfigPath, sxhkdConfigPath, bashrcPath, polybarPath, ... }: { pkgs, ... }: {
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
      ".config/polybar/polybar.ini".source = polybarPath;
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
    inactiveOpacity = 1;
    activeOpacity = 1; #"0.90";
    opacityRules = [ 
      "100:class_g = 'Firefox'" 
      "95:class_g = 'Alacritty' && focused" 
      "90:class_g = 'Alacritty' && !focused" 
    ];
    fade = true;
    vSync = true;
    shadow = true;
    fadeDelta = 4;
    #fadeSteps = [0.02 0.02];
    backend = "glx";
  };
}
