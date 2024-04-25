{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    talon.url = "github:nix-community/talon-nix";
  };

  outputs = { home-manager, ... }@inputs:
    let 
      system = "x86_64-linux";
      home-config = import ./home.nix;
      nixpkgs = inputs.nixpkgs-stable;
      unstableOverlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable { inherit (final) system; };
        talon = inputs.talon.packages.x86_64-linux.default;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        hostPlatform = nixpkgs.lib.mkDefault "x86_64-linux";
        overlays = [ unstableOverlay ];
      };
      configPaths = {
        alacrittyConfigPath = ./dotfiles/alacritty.toml;
        bashrcPath = ./dotfiles/bashrc;
      };
      specialArgs = { 
        home-manager = inputs.home-manager;
        initVimPath = ./dotfiles/init.vim;
      } // configPaths;
    in {
      nixosConfigurations.mapa-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        inherit specialArgs;
        modules = [ 
          ./mapa-laptop.nix
          ./configuration.nix
          ./hardware-configuration.nix
          ./hardware/mapa-laptop.nix
          ./neovim.nix
          ./xserver.nix
          inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.mapa = home-config "mapa-laptop" "mapa" configPaths;
              };
            }
        ];
      };
      nixosConfigurations.mapa-desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        inherit specialArgs;
        modules = [ 
          ./mapa-desktop.nix
          ./configuration.nix
          ./hardware/mapa-desktop.nix
          ./neovim.nix
          ./xserver.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              users.mapa = home-config "mapa-desktop" "mapa" configPaths;
            };
          }
        ];
      };
    };
}
