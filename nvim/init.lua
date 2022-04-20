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
vim.cmd('autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et')

-- Filetype Plugins
vim.cmd('autocmd FileType json       let g:indentLine_setConceal = 0')

-- #######
-- Plugins
-- #######
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  -- Color Scheme
  use {
    'morhetz/gruvbox',
    opt = true
  }

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
end)

-- #####################
-- Variables for Plugins
-- #####################
-- winresizer
vim.g.winresizer_gui_enable = 1


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

