-- mappings
vim.g.mapleader = ",";
vim.opt.signcolumn = "yes";
vim.keymap.set("n", "<leader>h", ":let @/ = \"\"<CR>", { silent = true })

-- set tab to be 2 spaces
vim.opt.shiftwidth = 2;
vim.opt.expandtab = true;
vim.opt.tabstop = 2;

vim.opt.updatetime = 750;

vim.keymap.set("", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("", "<Right>", "<Nop>", { silent = true })

-- ###############
-- # pckr config #
-- ###############
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/lewis6991/pckr.nvim", pckr_path })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()
require("pckr").add{
  -- syntax + language support
  "vim-crystal/vim-crystal";
  "mechatroner/rainbow_csv";
  "tpope/vim-rails";
  "tpope/vim-endwise";
  "slim-template/vim-slim";
  "thoughtbot/vim-rspec";
  { "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end
  };
  { "terrortylor/nvim-comment" };
  { "saghen/blink.cmp", tag = "v1.*" };
  -- Pinned to master: the default `main` branch is the in-progress rewrite,
  -- which drops the .setup() API and the textobjects integration.
  { "nvim-treesitter/nvim-treesitter",
    branch = "master",
    run = ":TSUpdate",
    requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    },
  };
  { "stevearc/conform.nvim" };

  "lewis6991/gitsigns.nvim";
  { "nvim-pack/nvim-spectre",
    requires = { 
      "nvim-lua/plenary.nvim",
    }
  };
  -- appearance
  "gmr458/vscode_modern_theme.nvim";
  { "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require('dashboard').setup {
        config = {
          packages = { enable = false },
          header = {
          '',  
          '███████╗████████╗██╗   ██╗ █ ███████╗    ██╗   ██╗██╗███╗   ███╗',
          '██╔════╝╚══██╔══╝██║   ██║   ██╔════╝    ██║   ██║██║████╗ ████║',
          '███████╗   ██║   ██║   ██║   ███████╗    ██║   ██║██║██╔████╔██║',
          '╚════██║   ██║   ██║   ██║   ╚════██║    ╚██╗ ██╔╝██║██║╚██╔╝██║',
          '███████║   ██║   ╚██████╔╝   ███████║     ╚████╔╝ ██║██║ ╚═╝ ██║',
          '╚══════╝   ╚═╝    ╚═════╝    ╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝',
          '',                                                   
          },
        }
      }
    end,
    requires = { "nvim-tree/nvim-web-devicons" }
  };

  -- navigation
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  };
  { "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    }
  };
  { "ruifm/gitlinker.nvim",
    requires = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require('gitlinker').setup({ opts = { add_current_line_on_normal_mode = false } })
    end
  };
}

-- ##############
-- # appearance #
-- ##############
require("vscode_modern").setup {
  cursorline = true,
  transparent_background = false,
  nvim_tree_darker = true,
}
vim.cmd.colorscheme("vscode_modern")

-- The theme predates these treesitter groups, so they fall back to defaults
-- that don't match VS Code: symbols inherit @string (orange) instead of the
-- constant blue, and def/class/end land on @keyword (blue) rather than the
-- control-flow purple. Colours below are the theme's own palette values.
local vscode = {
  purple = "#C586C0", -- keyword_control_flow: def, end, class, if, return
  blue = "#569CD6", -- keyword: and, or, not, self
  symbol = "#4FC1FF", -- constant: :a_symbol
}

local function apply_syntax_overrides()
  local set = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

  -- Ruby symbols. Treesitter captures these as @string.special.symbol, which
  -- inherits from @string; VS Code shows them in the constant blue.
  set("@string.special.symbol", { fg = vscode.symbol })
  set("@symbol", { fg = vscode.symbol })

  -- Definition and control-flow keywords -> purple.
  for _, group in ipairs({
    "@keyword.function",
    "@keyword.type",
    "@keyword.return",
    "@keyword.conditional",
    "@keyword.repeat",
    "@keyword.exception",
  }) do
    set(group, { fg = vscode.purple })
  end

  -- Plain @keyword stays blue: and/or/not/self are blue in VS Code, and `end`
  -- is captured as both @keyword and @keyword.function, so the more specific
  -- group above wins for it.
  set("@keyword", { fg = vscode.blue })
  set("@keyword.operator", { fg = vscode.blue })
end

apply_syntax_overrides()
-- Re-apply if the colorscheme is reloaded, which resets all highlight groups.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserSyntaxOverrides", {}),
  callback = apply_syntax_overrides,
})

vim.cmd("set number")
vim.cmd("set nowrap")

-- ##############
-- # navigation #
-- ##############
vim.keymap.set("", "<Leader>m", ":Neotree toggle<CR>", { silent = true });
vim.keymap.set("", "<Leader>M", ":Neotree reveal_file=%:p<CR>", { silent = true });
vim.keymap.set("", "<Leader>,", ":b#<CR>", { silent = true });

local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>F", telescope_builtin.live_grep, {})
vim.keymap.set("v", '<leader>F', "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>", {}) -- search selection
vim.keymap.set("n", "<leader>.", telescope_builtin.buffers, {})
require("telescope").setup {
  pickers = {
    buffers = {
      sort_mru = true,
      mappings = {
        n = { ["d"] = "delete_buffer", },
        i = { ["<c-d>"] = "delete_buffer", }
      }
    },
    colorscheme = {
      enable_preview = true
    }
  },
  extensions = {
    fzf = {},
  },
}
-- Compiled C sorter; much faster than the default Lua one on large repos.
pcall(require("telescope").load_extension, "fzf")

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    use_libuv_file_watcher = true,
  }
})

-- ###################
-- # gitsigns config #
-- ###################
require("gitsigns").setup {
  signs = {
    add = { text = "+" }
  },
  current_line_blame = true,
  current_line_blame_opts = { delay = 300, },
}
vim.cmd("highlight GitSignsAdd guifg=Green")
vim.cmd("highlight GitSignsChange guifg=#004acc")
vim.cmd("highlight GitSignsDelete guifg=DarkRed")
vim.cmd("highlight GitSignsCurrentLineBlame guifg=#555555")

-- #############################
-- # syntax + language support #
-- #############################
require("nvim_comment").setup({ line_mapping = "<leader>cl", operator_mapping = "<leader>c" })

-- ##############
-- # treesitter #
-- ##############
-- nvim-treesitter's master branch is in maintenance mode and ships queries
-- written against an older treesitter API. Because its runtimepath entry wins
-- over $VIMRUNTIME, those queries shadow Neovim's own for any language both
-- provide. The markdown one uses a #set-lang-from-info-string! directive whose
-- implementation is incompatible with 0.12, so every markdown file with a
-- fenced code block throws "attempt to call method 'range' (a nil value)" --
-- including in Telescope's preview window.
--
-- Drop the plugin's copies for the languages Neovim bundles, so its own
-- (correct) queries are used instead.
do
  local plugin_queries = vim.fn.stdpath("data")
    .. "/site/pack/pckr/opt/nvim-treesitter/queries/"
  for _, lang in ipairs({ "markdown", "markdown_inline", "lua", "vim", "vimdoc", "c", "query" }) do
    local dir = plugin_queries .. lang
    if vim.uv.fs_stat(dir) then
      vim.fn.delete(dir, "rf")
    end
  end
end

-- Parsers are fetched with `git clone` rather than a curl tarball from
-- codeload.github.com, which this network blocks (curl reports "could not
-- resolve host" even though DNS resolves it and git over HTTPS works).
require("nvim-treesitter.install").prefer_git = true

require("nvim-treesitter.configs").setup({
  -- Deliberately excludes the parsers Neovim already bundles: c, lua, markdown,
  -- markdown_inline, query, vim, vimdoc. nvim-treesitter's master branch ships
  -- injection queries written against an older treesitter API, and because its
  -- runtimepath entry wins over $VIMRUNTIME, those queries shadow Neovim's own
  -- and break any markdown file containing a fenced code block with
  -- "attempt to call method 'range' (a nil value)".
  ensure_installed = {
    "ruby", "embedded_template", "slim", "sql",
    "go", "gomod",
    "javascript", "json", "yaml", "html", "css",
    "bash", "diff", "git_rebase", "gitcommit",
  },
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",  -- a method, including def/end
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",     -- a class/module
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",     -- a do/end or {} block
        ["ib"] = "@block.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
      goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
    },
  },
})

-- ##############
-- # completion #
-- ##############
-- blink.cmp drives the popup. TAB/S-TAB cycle, CR accepts -- matching the
-- keys coc used, so muscle memory carries over.
require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-Space>"] = { "show" },
    ["<C-e>"] = { "hide" },
  },
  completion = {
    documentation = { auto_show = true },
    list = { selection = { preselect = false, auto_insert = false } },
  },
  signature = { enabled = true },
})

-- #######
-- # LSP #
-- #######
-- Neovim ships the vim.lsp.config API but no server definitions, so each
-- server is declared here rather than via nvim-lspconfig.
vim.lsp.config("ruby_lsp", {
  -- The asdf shim, so ruby-lsp runs under whichever Ruby the project pins.
  -- It must load the project's own gems to index them, so it has to match.
  -- Requires `gem install ruby-lsp` per Ruby version -- see README.
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    -- Formatting and diagnostics come from the project's own rubocop.
    formatter = "auto",
    linters = { "rubocop" },
  },
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = { usePlaceholders = true },
  },
})

vim.lsp.enable({ "ruby_lsp", "gopls" })

-- Buffer-local mappings, set only once a server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", {}),
  callback = function(event)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, "List references")
    map("n", "K", vim.lsp.buf.hover, "Hover docs")
    map("n", "<Leader>d", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<Leader>a", vim.lsp.buf.code_action, "Code action")

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Highlight the symbol under the cursor while idle.
    if client and client:supports_method("textDocument/documentHighlight") then
      local highlight_group = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Show the diagnostic for the current line in a float, as coc's
-- diagnostic.checkCurrentLine did.
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { source = true },
})

-- ##############
-- # formatting #
-- ##############
-- conform owns format-on-save for every filetype. Ruby has no entry, so it
-- falls back to the LSP (ruby-lsp -> the project's rubocop); the rest use a
-- dedicated formatter when one is on PATH.
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    go = { "gofmt" },
    lua = { "stylua" },
    sh = { "shfmt" },
    zsh = { "shfmt" },
  },
  format_on_save = function(bufnr)
    -- Let :noa w skip formatting when you need the file written verbatim.
    if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
      return
    end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
})

-- :Format to run it by hand, e.g. on a file you saved with formatting off.
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format current buffer" })

-- :FormatToggle to suspend format-on-save for this buffer.
vim.api.nvim_create_user_command("FormatToggle", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  print("format on save: " .. (vim.b.disable_autoformat and "off" or "on") .. " (buffer)")
end, { desc = "Toggle format on save for this buffer" })

-- Spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
