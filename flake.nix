{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      #inputs.utils.follows = "flake-utils";
    };
  };

  outputs = { home-manager, ... }@inputs:
    let 
      system = "x86_64-linux";
      home-config = import ./home.nix;
      nixpkgs = inputs.nixpkgs-unstable;
      pkgs = (import nixpkgs) {
        inherit system;
        config.allowUnfree = true;
        hostPlatform = nixpkgs.lib.mkDefault "x86_64-linux";
      };
      configPaths = {
        bspwmConfigPath = ./dotfiles/bspwmrc;
        sxhkdConfigPath = ./dotfiles/sxhkdrc;
        alacrittyConfigPath = ./dotfiles/alacritty.yml;
        bashrcPath = ./dotfiles/bashrc;
      };
      specialArgs = { 
        home-manager = inputs.home-manager;
        initVimPath = ./dotfiles/init.vim;
      } // configPaths;
    in {
      nixosConfigurations.den = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        inherit specialArgs;
        modules = [ 
          ./configuration.nix
          ./hardware-configuration.nix
          ./neovim.nix
          ./xserver.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.mapa = home-config "mapa" configPaths;
          }
        ];
      };
    };
}
