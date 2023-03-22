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
  };
}
