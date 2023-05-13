{ initVimPath, pkgs, ... }: 
let
  mapa-colors = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-colors";
    src = pkgs.fetchFromGitHub {
      owner = "MapaRaccoon";
      repo = "vim-colors";
      rev = "67b883f583268431ae3cf8eee1aff5aa2358a69d";
      sha256 = "00qbr0hab72w02184mjnz6ili56sgq44mlg4ar7r7gi4071jplsi";
    };
  };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    configure = {
      customRC = builtins.readFile initVimPath;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nvim-lspconfig
          telescope-nvim
          telescope_hoogle
          feline-nvim
          vim-nix
          mapa-colors
        ];
      };
    };
  };
}
