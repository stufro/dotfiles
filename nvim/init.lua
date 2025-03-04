-- mappings
vim.g.mapleader = ",";
vim.opt.signcolumn = "yes";
vim.keymap.set("n", "<leader>h", ":let @/ = \"\"<CR>", { silent = true })

-- set tab to be 2 spaces
vim.opt.shiftwidth = 2;
vim.opt.expandtab = true;
vim.opt.tabstop = 2;

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
  { "neoclide/coc.nvim", branch = "release" };

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

-- CoC
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : "<TAB>"', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- CoC - Jump to
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})

-- CoC - Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold"
})

-- CoC - Refactoring
vim.keymap.set("n", "<Leader>d", ":CocCommand document.renameCurrentWord<CR>", { silent = true })

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
