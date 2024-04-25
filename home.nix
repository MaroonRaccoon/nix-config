hostname: user: {  alacrittyConfigPath, bashrcPath, ... }: { pkgs, ... }: 
let
  dispatch-system = (import ./util.nix).dispatch-system;
  polybar-command = dispatch-system hostname {
    mapa-desktop = ''
      polybar desktop-left &
      polybar desktop-right &
    '';
    mapa-laptop = ''
      polybar laptop;
    '';
  };
in {
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "23.05";
    file = {
      ".alacritty.toml".source = alacrittyConfigPath;
      ".bashrc".source = bashrcPath;
    };
  };

  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    windowManager.bspwm = {
      enable = true;
      monitors = dispatch-system hostname {
        mapa-desktop = {
          "HDMI-0" = ["1" "2" "3" "4" "5"];
          "DP-1" = ["6" "7" "8" "9" "0"];
        };
        mapa-laptop = { };
      };
      settings = {
        border_width = 1;
        window_gap = 4;
        borderless_monocle = true;
        gapless_monocle = true;
      };
      extraConfig = ''
        ${
          dispatch-system hostname {
            mapa-desktop = ''
              xrandr --output HDMI-0 --primary --mode 2560x1440 --rate 75.00
              xrandr --output DP-1 --mode 1920x1080 --rate 60.00 --right-of HDMI-0
            '';
            mapa-laptop = "";
          }
        }

        bspc rule -a Zathura state=tiled

        feh --bg-fill ~/img/jacato-blanket.jpg &

        # start polybar from here since home-manager incorrectly starts it before bspwm if use services.polybar.script
        ${polybar-command}
      '';
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      "alt + Return"                = "alacritty";
      "alt + u"                     = "dmenu_run";
      "alt + b"                     = "firefox";
      "alt + {_,shift + }w"         = "bspc node -{c,k}";
      "alt + g"                     = "bspc node -s biggest.window";
      "alt + {t,shift + t,s,f}"     = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      "alt + ctrl + {m,x,y,z}"      = "bspc node -g {marked,locked,sticky,private}";
      "alt + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      "alt + {grave,Tab}"           = "bspc {node,desktop} -f last";
      "alt + {_,shift + }{1-9,0}"   = "bspc {desktop -f,node -d} '^{1-9,10}'";
    };
  };

  services.polybar = {
    enable = true;
    script = "";
    config = let
      bar-display = {
        width = "100%";
        height = "12pt";
        line-size = "12pt";
        border-size = "1pt";
        border-color = "#00000000";
        padding-left = "0";
        padding-right = "1";
        padding-top = "1";
        padding-bottom = "1";
        module-margin = "1";
        separator = "|";
        separator-foreground = "\${colors.disabled}";
        font-0 = "Fira Code:size=9;2";
      };
    in {
      "bar/desktop-left" = bar-display // {
        monitor = "HDMI-0";

        enable-ipc = true;

        tray-position = "right";

        modules-left = "bspwm";
        modules-center = "xwindow";
        modules-right = "cpu ram eth pulseaudio date";
      };
      "bar/desktop-right" = bar-display // {
        monitor = "DP-1";

        enable-ipc = true;

        tray-position = "right";

        modules-left = "bspwm";
        modules-center = "xwindow";
        modules-right = "cpu ram eth pulseaudio date";
      };
      "bar/laptop" = bar-display // {
        enable-ipc = true;

        modules-left = "bspwm";
        modules-center = "xwindow";
        modules-right = "cpu ram eth pulseaudio date";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume-prefix = "\"VOL \"";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";

        label-volume = "%percentage%%";

        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };
      "module/date" = {
        type = "internal/date";
        interval = "1";

        date = "%Y-%m-%d %l:%M:%S";

        label = "%date%";
        label-foreground = "\${colors.primary}";
      };
      "module/eth" = {
        type = "internal/network";
        interface-type = "wired";
        label-connected = "%downspeed:9% %local_ip%";
        label-disconnected = "QwQ";
      };
      "module/ram" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = "\"RAM \"";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage_used:2%%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = "2";
        format-prefix = "\"CPU \"";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage:2%%";
      };
      "module/xworkspaces" = {
        type = "internal/xworkspaces";

      };
      "module/bspwm" = {
        type = "internal/bspwm";
        pin-workspaces = true;
        label-monitor = "%name%";

        label-focused = "%name%";
        label-focused-background = "\${colors.background-alt}";
        label-focused-padding = "1";

        label-occupied = "%name%";
        label-occupied-padding = "1";

        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = "1";

        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = "1";
      };
      colors = {
        background = "#282A2E";
        background-alt = "#373B41";
        foreground = "#C5C8C6";
        primary = "#F0C674";
        secondary = "#8ABEB7";
        alert = "#A54242";
        disabled = "#707880";
      };
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
  
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set recolor
    '';
  };
}
