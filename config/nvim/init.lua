local vim = vim

vim.opt.autoread = true
vim.opt.clipboard:append({'unnamedplus'})
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.guifont = { 'DroidSansMono Nerd Font', "h11" }
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = 'tab:»-,trail:-,extends:»,precedes:«,nbsp:%'
vim.opt.mouse = 'a'
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.wrapscan = true
vim.wo.number = true

-- Tab, Indent
-- vim.opt.shiftwidth = 4
-- vim.opt.softtabstop = 4
-- vim.opt.tabstop = 4
-- vim.opt.expandtab = true
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
vim.cmd('filetype plugin indent on')
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
    use { 'morhetz/gruvbox' }

    use 'lukas-reineke/indent-blankline.nvim'

    use 'dense-analysis/ale'

    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('nvim-tree').setup()
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

    -- GitHub Copilot
    use { 'github/copilot.vim' }

    -- Git
    use {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    }

    -- Markdown
    use {
      'preservim/vim-markdown',
      requires = { 'godlygeek/tabular' },
      ft = { 'markdown' }
    }

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
      -- behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
      select = false,
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

-- ale
vim.g.ale_fix_on_save = 1
vim.g.ale_linters = {
  sql = { 'sqlfluff' },
}
vim.g.ale_fixers = {
  -- ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
  c = { 'clang-format' },
  cpp = { 'clang-format' },
  css = { 'prettier' },
  go = { 'gofmt' },
  html = { 'prettier' },
  lua = { 'luafmt' },
  javascript = { 'prettier', 'eslint' },
  markdown = { 'textlint' },
  ruby = { 'rufo' },
  rust = { 'rustfmt' },
  sql = { 'sqlfluff' },
  typescript = { 'prettier', 'eslint' },
}

-- git
local gitsigns = require('gitsigns')
gitsigns.setup {
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 500,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

-- winresizer
vim.g.winresizer_gui_enable = 1

-- ######
-- Keymap
-- ######
vim.keymap.set('n', '+', '<C-a>', { noremap = true })
vim.keymap.set('n', '-', '<C-x>', { noremap = true })
vim.keymap.set('n', '<Esc><Esc>', '<cmd>nohlsearch<CR><Esc>', { noremap = true })
vim.keymap.set('n', 'Y', 'y$', { noremap = true })
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', '<Left>', '<cmd>bp<CR>', { noremap = true })
vim.keymap.set('n', '<Right>', '<cmd>bn<CR>', { noremap = true })
vim.keymap.set('i', ';<CR>', '<End>;<CR>', { noremap = true })
vim.keymap.set('i', ',<CR>', '<End>,<CR>', { noremap = true })
vim.keymap.set('i', ';;', '<End>;', { noremap = true })
vim.keymap.set('i', ',,', '<End>,', { noremap = true })

-- ##################
-- Keymap for Plugins
-- ##################
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<leader>f', '<cmd>ALEFix<CR>', { noremap = true })
vim.keymap.set('n', '<leader>p', '<cmd>CtrlP<CR>', { noremap = true })
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFindFile<CR>', { noremap = true })
vim.keymap.set('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>', { noremap = true })

-- #####
-- Color
-- #####
vim.cmd.colorscheme('gruvbox')

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

