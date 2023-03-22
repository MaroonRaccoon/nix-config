" filetype
filetype plugin on
filetype indent on

set number

" windows
nnoremap s <C-w>

" leader
let mapleader=" "

" searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" indent
set et si autoindent sw=2 ts=2

" colors
set termguicolors
syntax on
colo purple

" navigation
nnoremap j gj
nnoremap k gk

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
