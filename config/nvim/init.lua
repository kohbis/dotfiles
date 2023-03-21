local vim = vim

-- GUI Font
vim.opt.guifont = { 'DroidSansMono Nerd Font', "h11" }

-- True Color
vim.o.termguicolors = true

-- Line Number
vim.wo.number = true

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

-- Autoread
vim.o.autoread = true

-- Tab, Indent
-- vim.o.shiftwidth = 4
-- vim.o.softtabstop = 4
-- vim.o.tabstop = 4
-- vim.o.expandtab = true
-- sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtab
vim.cmd('autocmd FileType c          setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType css        setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType go         setlocal sw=8 sts=8 ts=8 noet')
vim.cmd('autocmd FileType html       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType json       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType java       setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType markdown   setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType rust       setlocal sw=4 sts=4 ts=4 et')
vim.cmd('autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType sql        setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType toml       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType typescript setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et')
vim.cmd('autocmd FileType zig        setlocal sw=4 sts=4 ts=4 et')

-- setfiletype
vim.cmd('autocmd BufRead,BufNewFile *.njk setfiletype html')

-- Filetype Plugins
vim.cmd('autocmd FileType json let g:indentLine_setConceal = 0')

-- #######
-- Plugins
-- #######
vim.cmd [[packadd packer.nvim]]
require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'

    -- Denops
    use 'vim-denops/denops.vim'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'onsails/lspkind-nvim'

    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"

    -- Color Scheme
    use {
      'morhetz/gruvbox',
      opt = true
    }

    use 'lukas-reineke/indent-blankline.nvim'

    -- Load on a combination of conditions: specific filetypes or commands
    -- Also run code after load (see the "config" key)
    use {
      'dense-analysis/ale',
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
        'ruby',
        'zig'
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

    -- Comment
    use 'tpope/vim-commentary'

    -- CSV
    use 'Decodetalkers/csv-tools.lua'

    -- Delete/change/add parentheses/quotes/XML-tags/much more with ease
    use 'tpope/vim-surround'

    -- Fuzzy Finder
    use 'ctrlpvim/ctrlp.vim'

    -- Git diff
    use 'airblade/vim-gitgutter'

    -- Trail whitespace
    use 'ntpeters/vim-better-whitespace'

    -- Resize windows
    use 'simeji/winresizer'

    -- Rust
    use {
      'rust-lang/rust.vim',
      ft = { 'rust' }
    }

    -- Helm
    use {
      'towolf/vim-helm',
      ft = { 'yaml' }
    }

    -- SQL
    use {
      'mattn/vim-sqlfmt',
      ft = { 'sql' }
    }

    -- Terraform
    use {
      'hashivim/vim-terraform',
      ft = { 'terraform' }
    }

    -- Zig
    use {
      'ziglang/zig.vim',
      ft = { 'zig' }
    }

    -- Convert letter cases
    use {
      'kohbis/snacam.vim',
      branch = 'main'
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
local mason = require("mason")
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {}

    local node_root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
    local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

    if server_name == "tsserver" or server_name == "eslint" then
      if not is_node_repo then return end
    elseif server_name == "denols" then
      if is_node_repo then return end
      opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
      opts.init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://cdn.nest.land"] = true,
              ["https://crux.land"] = true
            }
          }
        }
      }
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    opts.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    nvim_lsp[server_name].setup(opts)

    vim.cmd [[ do User LspAttachBuffers ]]
  end,
}

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
      -- For `luasnip` user.
      -- require('luasnip').lsp_expand(args.body)
      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    -- { name = 'luasnip' },
    -- { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
    -- { name = 'treesitter' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      with_text = true,
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
  mapping = cmp.mapping.preset.cmdline(),
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
vim.api.nvim_set_keymap('i', ';;', '<End>;', { noremap = true })
vim.api.nvim_set_keymap('i', ',,', '<End>,', { noremap = true })

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

-- ##########
-- Custom Lua
-- ##########
local loadModule = function(module)
  local ok, _ = pcall(require, module)
  if not ok then
    print('unloadable module: '..module)
  end
end
loadModule('local')

