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
vim.cmd('autocmd FileType helm       setlocal sw=2 sts=2 ts=2 et')
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
vim.cmd('autocmd FileType tpl        setlocal sw=2 sts=2 ts=2 et')
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
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Denops
  { 'vim-denops/denops.vim' },

  -- Snacks.nvim (required for claudecode.nvim)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {},
  },

  -- Claude Code
  {
    'coder/claudecode.nvim',
    lazy = false,
    opts = {
      auto_start = true,
    },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },

  -- LSP
  { 'neovim/nvim-lspconfig' },
  {
    'mason-org/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "ts_ls",
          "denols",
          "eslint",
        }
      })

      local node_root_dir = vim.fs.root(0, { "package.json", "node_modules" })
      local is_node_repo = node_root_dir ~= nil

      local servers = mason_lspconfig.get_installed_servers()
      for _, server_name in ipairs(servers) do
        local opts = {}

        if server_name == "tsserver" or server_name == "eslint" then
          if not is_node_repo then goto continue end
        elseif server_name == "denols" then
          if is_node_repo then goto continue end
          opts.root_markers = { "deno.json", "deno.jsonc", "deps.ts", "import_map.json" }
          opts.settings = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                }
              }
            }
          }
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        opts.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        if not vim.lsp.config[server_name] then
          vim.lsp.config[server_name] = opts
        end
        vim.lsp.enable(server_name)

        vim.cmd [[ do User LspAttachBuffers ]]

        ::continue::
      end
    end,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
    config = function()
      vim.opt.completeopt = "menu,menuone,noselect"
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      cmp.setup({
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<Up>'] = cmp.mapping.select_prev_item(),
          ['<Down>'] = cmp.mapping.select_next_item(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-y>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = false },
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'copilot' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            with_text = true,
            before = function(entry, vim_item)
              vim_item.menu = ({
                path = '[PATH]',
                buffer = '[BUF]',
                nvim_lsp = '[LSP]',
                tmux = '[TMUX]',
              })[entry.source.name]
              return vim_item
            end
          })
        }
      })
      cmp.setup.cmdline('/', {
        sources = { { name = 'buffer' } }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = 'path' } },
          { { name = 'cmdline' } }
        )
      })
    end,
  },

  -- Color Scheme
  { 'morhetz/gruvbox' },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- brew install ripgrep
    },
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Telescope find files' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Telescope live grep' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Telescope buffers' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Telescope help tags' },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  {
    'dense-analysis/ale',
    init = function()
      vim.g.ale_fix_on_save = 1
      vim.g.ale_linters = {
        sql = { 'sqlfluff' },
      }
      vim.g.ale_fixers = {
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
    end,
    keys = {
      { '<leader>f', '<cmd>ALEFix<CR>', desc = 'ALEFix' },
    },
  },

  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    opts = {
      filters = {
        git_ignored = false,
      },
    },
    keys = {
      { '<C-N>', '<cmd>NvimTreeToggle<CR>', desc = 'NvimTree Toggle' },
      { '<leader>n', '<cmd>NvimTreeFindFile<CR>', desc = 'NvimTree Find File' },
      { '<leader>r', '<cmd>NvimTreeRefresh<CR>', desc = 'NvimTree Refresh' },
    },
  },

  {
    'akinsho/bufferline.nvim',
    opts = {
      options = {
        numbers = 'both',
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " "
              or (e == "warning" and " " or "" )
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
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    opts = {
      options = { theme = 'gruvbox' }
    },
  },

  { 'jiangmiao/auto-pairs' },

  -- Comment
  { 'tpope/vim-commentary' },

  -- CSV
  { 'Decodetalkers/csv-tools.lua' },

  -- Delete/change/add parentheses/quotes/XML-tags/much more with ease
  { 'tpope/vim-surround' },

  -- Fuzzy Finder
  {
    'ctrlpvim/ctrlp.vim',
    keys = {
      { '<leader>p', '<cmd>CtrlP<CR>', desc = 'CtrlP' },
    },
  },

  -- GitHub Copilot
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        markdown = true,
        yaml = true,
      }
    end,
    keys = {
      { '<C-J>', 'copilot#Accept("<CR>")', mode = 'i', expr = true, silent = true, replace_keycodes = false, desc = 'Copilot Accept' },
      { '<C-L>', '<Plug>(copilot-accept-word)', mode = 'i', desc = 'Copilot Accept Word' },
    },
  },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
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
    },
  },

  -- Markdown
  {
    'preservim/vim-markdown',
    dependencies = { 'godlygeek/tabular' },
    ft = { 'markdown' },
    init = function()
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },

  -- Delete Neovim buffers without losing window layout
  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete' },
    keys = {
      { '<leader>bd', '<cmd>Bdelete<CR>', desc = 'Delete buffer' },
    },
  },

  -- Trail whitespace
  { 'ntpeters/vim-better-whitespace' },

  -- Resize windows
  {
    'simeji/winresizer',
    init = function()
      vim.g.winresizer_gui_enable = 1
    end,
  },

  -- Rust
  {
    'rust-lang/rust.vim',
    ft = { 'rust' },
  },

  -- Helm
  {
    'towolf/vim-helm',
    ft = { 'yaml' },
  },

  -- Terraform
  {
    'hashivim/vim-terraform',
    ft = { 'terraform' },
  },

  -- Zig
  {
    'ziglang/zig.vim',
    ft = { 'zig' },
  },

  -- Convert letter cases
  {
    'kohbis/snacam.vim',
    branch = 'main',
  },
}, {
  ui = {
    border = 'single',
  },
  -- Lazy.nvim keymap
  keys = {
    { '<leader>l', '<cmd>Lazy<CR>', desc = 'Open Lazy plugin manager' },
  },
})

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
