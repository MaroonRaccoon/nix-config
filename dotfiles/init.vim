" filetype
filetype plugin on
filetype indent on

set number

" windows
nnoremap s <C-w>

" leader
let mapleader=" "
let maplocalleader=" "


" searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" indent
set et si autoindent sw=4 ts=4
set breakindent

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

" hop
nnoremap \ :HopWord<CR>

" neorg
nnoremap <localleader>ni :Neorg index<CR>

" gpt
nnoremap <leader>gwa :GpWhisperAppend<CR>
nnoremap <leader>gwr :GpWhisperRewrite<CR>

lua <<EOF

require'gp'.setup {
    openai_api_key = { "cat", "/home/mapa/.openai-api-key" },
    agents = {
        {
            name = "math",
            chat = false,
            command = true,
            model = { model = "gpt-4" },
            system_prompt = "You are a speech recognition assistant for math writing. The user will have their speech transcribed into text by a speech recognition model. You will receive this text as input. Your job is to translate this text into prose and LaTeX code. Do not include any commentary or additional text; your responses will be inserted directly into a LaTeX document. The speech recognition model the user uses may not transcribe the user's speech perfectly, so do your best to infer what the user wants even if the text doesn't quite make sense.",
        }
    },
}


require("lean").setup {
  lsp = { on_attach = on_attach },
  mappings = true,
}

-- this fixes concealer not working (e.g. for links)
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.norg"},
  command = "set conceallevel=3"
})

require("neorg").setup {
  load = {
    ["core.defaults"] = { },
    ["core.concealer"] = { },
    ["core.keybinds"] = {
        config = {
            hook = function(keys)
                keys.remap_key("norg", "i", "<M-CR>", "<C-CR>")
            end
        }
    },
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/notes",
        },
        default_workspace = "notes",
      },
    },
  },
}

lsp = require'lspconfig'

lsp.hls.setup {
    filetypes = { 'haskell', 'lhaskell', 'cabal' }
}

lsp.nil_ls.setup {}
lsp.jedi_language_server.setup {}
lsp.pyright.setup {}

lsp.clangd.setup {}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
on_attach = function(ev)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = ev.buf }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
end
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = on_attach,
})

require'nvim-treesitter.configs'.setup {
  auto_install = false,
  highlight = {
    enable = true
  }
}

require'treesitter-context'.setup {
    enable = true;
    mode = 'topline'
}

require'hop'.setup()

local cmp = require'cmp'
cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['C-<Space>'] = cmp.mapping.complete,
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.clangd.setup { capabilities = capabilities }

EOF

