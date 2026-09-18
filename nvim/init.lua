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
  "github/copilot.vim";
  { "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end
  };
  { "terrortylor/nvim-comment" };
  { "saghen/blink.cmp", tag = "v1.*" };

  "lewis6991/gitsigns.nvim";
  { "nvim-pack/nvim-spectre",
    requires = { 
      "nvim-lua/plenary.nvim",
    }
  };
  { "CopilotC-Nvim/CopilotChat.nvim",
    config = function()
      require("CopilotChat").setup({})
    end,
    requires = {
      "github/copilot.vim",
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
      "nvim-lua/plenary.nvim"
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
  }
}

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

    -- Format on save, replacing coc.preferences.formatOnSave.
    if client and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        group = vim.api.nvim_create_augroup("UserLspFormat" .. event.buf, { clear = true }),
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 2000 })
        end,
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

-- Copilot
vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-w>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-p>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-n>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-c>', '<Plug>(copilot-suggest)')

vim.keymap.set('n', '<leader>gc', ':CopilotChat<CR>', { silent = true })
vim.keymap.set('v', '<leader>gc', 'y<ESC>:CopilotChat <c-r>0<CR>', { silent = true })
