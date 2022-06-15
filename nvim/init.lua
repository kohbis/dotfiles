local vim = vim

-- Line Number
vim.wo.number = true

-- True Color
vim.o.termguicolors = true

-- Mouse
vim.opt.mouse = 'a'

-- Clipboard
vim.opt.clipboard:append({'unnamedplus'})

-- Whitespace Charactors
vim.o.list = true
vim.o.listchars = 'tab:»-,trail:-,extends:»,precedes:«,nbsp:%'

-- Cursor
vim.o.cursorline = true

-- Ignore uppercase/lowercase
vim.o.ignorecase = true
-- Disable ignorecase when input uppercase
vim.o.smartcase = true
-- Search to the end & Return to the beginning
vim.o.wrapscan = true

-- New Window
vim.o.splitbelow = true
vim.o.splitright = true

-- Command window height
vim.o.cmdheight = 1

-- Tab, Indent
-- vim.o.shiftwidth = 4
-- vim.o.softtabstop = 4
-- vim.o.tabstop = 4
-- vim.o.expandtab = true
-- sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtab
vim.cmd('autocmd FileType c          setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType go         setlocal sw=8 sts=8 ts=8 noet')
vim.cmd('autocmd FileType java       setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType rust       setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType toml       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType typescript setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et')

-- Filetype Plugins
vim.cmd('autocmd FileType json       let g:indentLine_setConceal = 0')

-- #######
-- Plugins
-- #######
vim.cmd [[packadd packer.nvim]]
require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use "williamboman/nvim-lsp-installer"

    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'onsails/lspkind-nvim'

    -- Color Scheme
    use {
      'morhetz/gruvbox',
      opt = true
    }

    use 'lukas-reineke/indent-blankline.nvim'

    -- Load on a combination of conditions: specific filetypes or commands
    -- Also run code after load (see the "config" key)
    use {
      'w0rp/ale',
      ft = {
        'sh',
        'bash',
        'c',
        'cpp',
        'cmake',
        'html',
        'markdown',
        'vim',
        'rust',
        'go',
        'ruby'
      },
      cmd = 'ALEEnable',
      config = 'vim.cmd[[ALEEnable]]'
    }

    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('nvim-tree').setup {
        }
      end
    }

    use {
      'akinsho/bufferline.nvim',
      config = function()
        require('bufferline').setup {
          options = {
            numbers = 'both',
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              local s = " "
              for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " "
                  or (e == "warning" and " " or "" )
                s = s .. n .. sym
              end
              return s
            end,
            offsets = {
              {
                filetype = "NvimTree",
                text = "",
              }
            }
          }
        }
      end
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require('lualine').setup {
          options = { theme = 'gruvbox' }
        }
      end
    }

    use 'jiangmiao/auto-pairs'

    use 'tpope/vim-commentary'

    -- Delete/change/add parentheses/quotes/XML-tags/much more with ease
    use 'tpope/vim-surround'

    -- Fuzzy Finder
    use 'ctrlpvim/ctrlp.vim'

    -- Git diff
    use 'airblade/vim-gitgutter'

    -- Trail whitespace
    use 'bronson/vim-trailing-whitespace'

    -- Resize windows
    use 'simeji/winresizer'

    -- Rust
    use {
      'rust-lang/rust.vim',
      ft = { 'rust' }
    }

    -- Terraform
    use {
      'hashivim/vim-terraform',
      ft = { 'terraform' }
    }

    -- SQL
    use {
      'mattn/vim-sqlfmt',
      ft = { 'sql' }
    }

    -- defaults
    -- -- Simple plugins can be specified as strings
    -- use '9mm/vim-closer'
    --
    -- -- Lazy loading:
    -- -- Load on specific commands
    -- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
    --
    -- -- Load on an autocommand event
    -- use {'andymass/vim-matchup', event = 'VimEnter'}
    --
    -- -- Plugins can have dependencies on other plugins
    -- use {
    --   'haorenW1025/completion-nvim',
    --   opt = true,
    --   requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
    -- }
    --
    -- -- Plugins can also depend on rocks from luarocks.org:
    -- use {
    --   'my/supercoolplugin',
    --   rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
    -- }
    --
    -- -- You can specify rocks in isolation
    -- use_rocks 'penlight'
    -- use_rocks {'lua-resty-http', 'lpeg'}
    --
    -- -- Local plugins can be included
    -- use '~/projects/personal/hover.nvim'
    --
    -- -- Plugins can have post-install/update hooks
    -- use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
    --
    -- -- Post-install/update hook with neovim command
    -- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    --
    -- -- Post-install/update hook with call of vimscript function with argument
    -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

    -- -- Use dependency and run lua function after load
    -- use {
    --   'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    --   config = function() require('gitsigns').setup() end
    -- }
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})

-- #####################
-- Settings for Plugins
-- #####################
-- LSP
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    opts.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.
      -- For `luasnip` user.
      -- require('luasnip').lsp_expand(args.body)
      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-y>'] = cmp.mapping.complete(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' },
    -- { name = 'luasnip' },
    -- { name = 'ultisnips' },
    { name = 'buffer' },
    { name = 'path' },
    -- { name = 'treesitter' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      with_text = true,
      maxwidth = 50,
      before = function (entry, vim_item)
        vim_item.menu = ({
          -- luasnip = '[SNIP]',
          path = '[PATH]',
          buffer = '[BUF]',
          -- calc = '[CALC]',
          -- nuspell = '[SPELL]',
          -- spell = '[SPELL]',
          -- emoji = '[EMOJI]',
          -- treesitter = '[TS]',
          nvim_lsp = '[LSP]',
          -- cmp_tabnine = '[TN]',
          -- latex_symbols = '[TEX]',
          tmux = '[TMUX]',
          -- conjure = '[CJ]',
          -- orgmode = '[ORG]'
        })[entry.source.name]
        return vim_item
      end
    })
  }
})
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- winresizer
vim.g.winresizer_gui_enable = 1

-- vim-sqlfmt
vim.g.sqlfmt_program = "sqlformat --reindent --keyword upper -o %s -"

-- ######
-- Keymap
-- ######
vim.api.nvim_set_keymap('n', '+', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('n', '-', '<C-x>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Esc><Esc>', '<cmd>nohlsearch<CR><Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })
vim.api.nvim_set_keymap('n', '<Left>', '<cmd>bp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Right>', '<cmd>bn<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', ';<CR>', '<End>;<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', ',<CR>', '<End>,<CR>', { noremap = true })
-- ##################
-- Keymap for Plugins
-- ##################
vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>NvimTreeFindFile<CR>', { noremap = true })

-- #####
-- Color
-- #####
vim.cmd('colorscheme gruvbox')

