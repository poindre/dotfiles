--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, and understand
  what your configuration is doing.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- config cspell 

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Github copilot
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     local keymap = vim.keymap.set
  --     keymap(
  --       "i",
  --       "<C-g>",
  --       'copilot#Accept("<CR>")',
  --       { silent = true, expr = true, script = true, replace_keycodes = false }
  --     )
  --     keymap("i", "<C-.>", "<Plug>(copilot-next)")
  --     keymap("i", "<C-,>", "<Plug>(copilot-previous)")
  --     keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
  --     keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
  --   end,
  -- },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-g>",
          },
        },
        panel = {
          enabled = true,
        },
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    config = function ()
      require("CopilotChat").setup({
        model = "claude-3.7-sonnet",
        context = "buffer",
        system_prompt = "コメントは日本語でお願いします",
        show_help = "yes",
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
            mapping = '<leader>ce',
            description = "コードの説明をお願いする",
          },
          Review = {
            prompt = '/COPILOT_REVIEW コードを日本語でレビューしてください。',
            mapping = '<leader>cr',
            description = "コードのレビューをお願いする",
          },
          Fix = {
            prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
            mapping = '<leader>cf',
            description = "コードの修正をお願いする",
          },
          Optimize = {
            prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
            mapping = '<leader>co',
            description = "コードの最適化をお願いする",
          },
          Docs = {
            prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
            mapping = '<leader>cd',
            description = "コードのドキュメント作成をお願いする",
          },
          Tests = {
            prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
            mapping = '<leader>ct',
            description = "テストコード作成をお願いする",
          },
          FixDiagnostic = {
            prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。',
            mapping = '<leader>cd',
            description = "コードの修正をお願いする",
            selection = require('CopilotChat.select').diagnostics,
          },
          Commit = {
            prompt =
            '実装差分に対するコミットメッセージを日本語で記述してください。',
            mapping = '<leader>cco',
            description = "コミットメッセージの作成をお願いする",
            selection = require('CopilotChat.select').gitdiff,
          },
          CommitStaged = {
            prompt =
            'ステージ済みの変更に対するコミットメッセージを日本語で記述してください。',
            mapping = '<leader>cs',
            description = "ステージ済みのコミットメッセージの作成をお願いする",
            selection = function(source)
              return require('CopilotChat.select').gitdiff(source, true)
            end,
          },
        },
      })
    end
    -- See Commands section for default commands if you want to lazy load on them
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- plugins/null-ls.lua
    'nvimtools/none-ls.nvim',
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local null_ls = require('null-ls')

      local cspell_config_dir = '~/.config/nvim/cspell'
      local cspell_data_dir = '~/.local/share/cspell'
      local cspell_files = {
        config = vim.fn.expand(cspell_config_dir .. '/cspell.json'),
        dotfiles = vim.fn.expand(cspell_config_dir .. '/dotfiles.txt'),
        vim = vim.fn.expand(cspell_data_dir .. '/vim.txt.gz'),
        user = vim.fn.expand(cspell_data_dir .. '/user.txt'),
      }

      -- vim辞書がなければダウンロード
      if vim.fn.filereadable(cspell_files.vim) ~= 1 then
        local vim_dictionary_url = 'https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz'
        io.popen('curl -fsSLo ' .. cspell_files.vim .. ' --create-dirs ' .. vim_dictionary_url)
      end

      -- ユーザー辞書がなければ作成
      if vim.fn.filereadable(cspell_files.user) ~= 1 then
        io.popen('mkdir -p ' .. cspell_data_dir)
        io.popen('touch ' .. cspell_files.user)
      end

      local group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = false })
      local event = 'BufWritePre'
      local async = false

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.rubocop.with({
            command = "bundle",
            args = vim.fn.executable("bundle") == 1 and
              { "exec", "rucocop", "--format", "json", "--force-exclusion", "--stdin", "$FILENAME" } or
              nil,
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          null_ls.builtins.formatting.rubocop.with({
            command = "bundle",
            args = vim.fn.executable("bundle") == 1 and
              { "exec", "rucocop", "--auto-correct", "--stdin", "$FILENAME", "--stdout" } or
              nil,
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          -- null_ls.builtins.formatting.biome,
          -- null_ls.builtins.formatting.stylelint.with({
          --   condition = function()
          --     return vim.fn.executable('stylelint') > 0
          --   end
          -- }),
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.eslint,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.formatting.stylelint,
          -- null_ls.builtins.diagnostics.cspell.with({
          --   diagnostics_postprocess = function(diagnostic)
          --     -- レベルをWARNに変更（デフォルトはERROR）
          --     diagnostic.severity = vim.diagnostic.severity["WARN"]
          --   end,
          --   -- condition = function()
          --     -- cspellが実行できるときのみ有効
          --     -- return vim.fn.executable('cspell') > 0
          --   -- end,
          --   -- 起動時に設定ファイル読み込み
          --   extra_args = { '--config', vim.fn.expand(cspell_files.config) },
          --   disabled_filetypes = { "NvimTree" },
          --   debounce = 2000,
          --   -- 変更した箇所のみをチェックする
          --   method = null_ls.methods.DIAGNOSTICS_ON_CHANGE
          -- })
        },
        debug= false,
        on_attach = function(client, bufnr)
          if client.supports_method('textDocument/formatting') then
            vim.keymap.set('n', '<Leader>f', function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), timeout = 10000 })
            end, { buffer = bufnr, desc = '[lsp] format' })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
              buffer = bufnr,
              group = group,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  async = async,
                  timeout = 10000,
                  filter = function(_client)
                    return _client.name == "null-ls"
                  end
                })
              end,
              desc = '[lsp] format on save',
            })
          end

          if client.supports_method('textDocument/rangeFormatting') then
            vim.keymap.set('x', '<Leader>f', function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), timeout = 10000  })
            end, { buffer = bufnr, desc = '[lsp] format' })
          end
        end,
      })
    end
  },

  -- {
  --   -- prettier.nvim
  --   'MunifTanjim/prettier.nvim',
  -- },

  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*",
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip'
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', 
    opts = {}
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = 'M' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.cmd('colorscheme everforest')
    end
  },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha",
  --     })
  --   end
  -- },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    -- opts = {
    --   char = '┊',
    --   show_trailing_blankline_indent = false,
    -- },
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim', 
    opts = {}
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    'nvim-telescope/telescope-ui-select.nvim'
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    "slim-template/vim-slim",
    ft = "slim"
  },

  {
    -- filer
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local function tree_on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.del('n', 's', { buffer = bufnr })

        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open file'))
      end

      require('nvim-tree').setup({
        sort_by = 'case_sensitive',
        on_attach = tree_on_attach,
        view = {
          width = 50,
        },
        filters = {
          custom = {'.DS_Store'}
        }
      })
    end
  },

  {
    -- Auto completion of brackets
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  },

  {
    -- nvim-ts-autotag
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    -- Highlight current word
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({})
    end
  },

  {
    -- surraound
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end
  },

  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  {
    'mattn/emmet-vim'
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.showmatch = true

vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.whichwrap = 'b,s,h,l,[,],<,>,~'

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { 'menuone', 'noselect' }

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require("telescope").load_extension, 'ui-select')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]iles Live [G]rep' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'css', 'vimdoc', 'vim', 'vue', 'ruby', 'slim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  -- auto_install = false,

  endwise = {
    enable = true
  },
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  -- autotag = {
  --   enable = true,
  -- },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- LSPサーバーのフォーマット機能を無効にする (Prettier によるフォーマットを利用)
  -- client.resolved_capabilities.document_formatting = true

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  intelephense = {},
  -- eslint = {},
  html = {},
  jsonls = {},
  solargraph = {},
  -- biome = {},

  -- Vue 3        
  -- volar = {
  --   init_options = {
  --     vue = {
  --       hybridMode = false,
  --     },
  --   },
  --   settings = {
  --     typescript = {
  --       inlayHints = {
  --         enumMemberValues = {
  --           enabled = true,
  --         },
  --         functionLikeReturnTypes = {
  --           enabled = true,
  --         },
  --         propertyDeclarationTypes = {
  --           enabled = true,
  --         },
  --         parameterTypes = {
  --           enabled = true,
  --           suppressWhenArgumentMatchesName = true,
  --         },
  --         variableTypes = {
  --           enabled = true,
  --         },
  --       },
  --     },
  --   },
  -- },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- TypeScript
  ts_ls = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'
local lspconfig = require 'lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      -- https://github.com/neovim/nvim-lspconfig/pull/3232#issuecomment-2331025714
      lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      })
    end,
    ['ts_ls'] = function()
      local vue_typescript_plugin = require("maon-registry").get_package("vue-language-server").get_install_path() .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"

      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue"},
        init_options = {
          preferences = {
            importModuleSpecifierPrederence = "relative"
          },
          root_dir = lspconfig.util.root_pattern("package.json"),
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_typescript_plugin,
              languages = { "javascript", "typescript", "vue" }
            }
          }
        }
      })
    end
  }
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    -- { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 2 },
    { name = 'path' },
  },
}

-- nvim-tree mappings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', '<C-n>', require('nvim-tree.api').tree.toggle, { desc = 'Toggle Tree' })
vim.keymap.set('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = '[C]ode [A]ction' })

-- Custom keymaps
-- Replace ESC
vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Replace ESC' })
vim.keymap.set('i', '<C-j>', 'j', { desc = 'Replace ESC' })
vim.keymap.set('i', 'kk', '<ESC>', { desc = 'Replace ESC' })
vim.keymap.set('i', '<C-k>', 'k', { desc = 'Replace ESC' })

-- Toogle Search Highlight
vim.keymap.set('n', '<ESC><ESC>', ':<C-u>set nohlsearch!<CR>', { desc = 'Toogle Search Highlight' })

-- Change Windows key mappings
vim.keymap.set('n', 's', '<Nop>', { desc = 'Change Windows key mappings' })
vim.keymap.set('n', 'sj', '<C-w>j', { desc = 'Change Windows key mappings: Go to left Window' })
vim.keymap.set('n', 'sk', '<C-w>k', { desc = 'Change Windows key mappings: Go to top Window' })
vim.keymap.set('n', 'sl', '<C-w>l', { desc = 'Change Windows key mappings: Go to right Window' })
vim.keymap.set('n', 'sh', '<C-w>h', { desc = 'Change Windows key mappings: Go to left Window' })
vim.keymap.set('n', 'sJ', '<C-w>J', { desc = 'Change Windows key mappings: Go to left Window' })
vim.keymap.set('n', 'sK', '<C-w>K', { desc = 'Change Windows key mappings: Go to top Window' })
vim.keymap.set('n', 'sL', '<C-w>L', { desc = 'Change Windows key mappings: Go to right Window' })
vim.keymap.set('n', 'sH', '<C-w>H', { desc = 'Change Windows key mappings: Go to left Window' })

-- Move cursor on display line
vim.keymap.set('n', 'j', 'gj', { desc = 'Toogle Search Highlight' })

-- Add Empty line
vim.keymap.set('n', '<Leader>jj', 'o<ESC>k', { desc = 'Add Empty line: at bottom' })
vim.keymap.set('n', '<Leader>kk', 'O<ESC>j', { desc = 'Add Empty line: at top' })

-- Save Shortcut
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save Shortcut' })

-- diffview mappings
vim.keymap.set('n', 'df', ':DiffviewOpen', { desc = 'Diffview Open: diff current' })
vim.keymap.set('n', 'dh', ':DiffviewFileHistory', { desc = 'Diffview Open: diff file history' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
