{ initVimPath, pkgs, ... }: 
let
  mapa-colors = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-colors";
    src = pkgs.fetchFromGitHub {
      owner = "MaroonRaccoon";
      repo = "vim-colors";
      rev = "67b883f583268431ae3cf8eee1aff5aa2358a69d";
      sha256 = "sha256-UdMrwwEkvpNPVuTRSgh+2pRIo/lWVoKCAFycpSDICwM=";
    };
  };
  neorg-telescope = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neorg-telescope";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-neorg";
      repo = "neorg-telescope";
      rev = "1310d4aaefd8149c9839bbe1d5610e94389e2f0e";
      sha256 = "sha256-jVfpSWPjSSbbsQns8n7TaAiSJLZ9EPEYVl8mibKH8Mw=";
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
          (nvim-treesitter.withPlugins (p: [ p.cpp p.haskell p.norg ]))
          feline-nvim
          vim-nix
          mapa-colors
          hop-nvim
          luasnip
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp_luasnip
          neorg
          neorg-telescope
        ];
      };
    };
  };
}
