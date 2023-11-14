-- REQ: Configures neovim using lua. <skr 2023-04-30>

-- SEE: https://neovim.io/doc/user/lua-guide.html <>

local call = vim.call
local cmd  = vim.cmd
local set  = vim.o
local gbl  = vim.g

-- SEE: https://github.com/junegunn/vim-plug <>
cmd [[
  let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
  if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
]]
local plug = vim.fn['plug#']

call('plug#begin')

-- SEE: https://github.com/carlsmedstad/vim-bicep <>
plug('carlsmedstad/vim-bicep')

-- SEE: https://github.com/hashivim/vim-terraform <>
plug('hashivim/vim-terraform')
gbl.terraform_align = 1
gbl.terraform_fmt_on_save = 1

-- SEE: https://github.com/neovim/nvim-lspconfig <>
plug('neovim/nvim-lspconfig')

-- SEE: https://github.com/nvim-treesitter/nvim-treesitter <>
-- HACK: Using special syntax to workaround reserved word attribute. <>
local treesitter_options = {}
treesitter_options["do"] = ':TSUpdate'
plug('nvim-treesitter/nvim-treesitter', treesitter_options)

-- SEE: https://github.com/psf/black <>
plug('psf/black', {branch = 'stable'})

-- SEE: https://github.com/vim-crystal/vim-crystal <>
plug('vim-crystal/vim-crystal')

-- SEE: https://github.com/fatih/vim-go <>
-- HACK: Using special syntax to workaround reserved word attribute. <>
plug('fatih/vim-go')
gbl.go_def_mapping_enabled = 0

-- SEE: https://github.com/hrsh7th/nvim-cmp <>
plug('hrsh7th/cmp-nvim-lsp')
plug('hrsh7th/cmp-buffer')
plug('hrsh7th/cmp-path')
plug('hrsh7th/cmp-cmdline')
plug('hrsh7th/nvim-cmp')
plug('hrsh7th/cmp-vsnip')
plug('hrsh7th/vim-vsnip')

-- SEE: https://github.com/nvim-telescope/telescope.nvim <>
plug('nvim-lua/plenary.nvim')
plug('nvim-telescope/telescope.nvim', {branch = '0.1.x'})

call('plug#end')

-- SEE: https://github.com/hrsh7th/nvim-cmp <>
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- SEE: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md <>
local lsp = require('lspconfig')

lsp.bicep.setup({
  cmd = { "dotnet", "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll" };

})

lsp.crystalline.setup({
  capabilities = capabilities
})

lsp.eslint.setup({
  capabilities = capabilities
})

-- SEE: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration <>
lsp.gopls.setup({
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = lsp.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities
})

lsp.omnisharp.setup({
  cmd = { "dotnet", "/usr/local/bin/omnisharp-roslyn/OmniSharp.dll" };
  capabilities = capabilities
})

lsp.terraformls.setup({
  capabilities = capabilities
})

lsp.tflint.setup({
  capabilities = capabilities
})

lsp.pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          -- ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  },
  capabilities = capabilities
})

-- SEE: https://github.com/nvim-treesitter/nvim-treesitter <>
require 'nvim-treesitter.configs'.setup({
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "bash", "vimdoc", "go", "lua", "vim" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true
  }
})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

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
  end,
})

-- SEE: https://github.com/nvim-telescope/telescope.nvim <>
local telescope = require('telescope')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- NOTE: disable arrow keys. <>
keys = {"<Up>", "<Down>", "<Left>", "<Right>"}
modes = {"n", "v"}

for _, key in pairs(keys) do
  for _, mode in pairs(modes) do
    vim.api.nvim_set_keymap(mode, key, "<Nop>", {})
  end
end

-- NOTE: Set indentation options. <>
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true

-- NOTE: Terminal-mode bindings <rbt>
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
