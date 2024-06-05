-- mappings
vim.g.mapleader = ",";
vim.opt.signcolumn = "yes";
vim.keymap.set("n", "<leader>h", ":let @/ = \"\"<CR>", { silent = true })

-- set tab to be 2 spaces
vim.opt.shiftwidth = 2;
vim.opt.expandtab = true;

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
      require("nvim-autopairs").setup {}
    end
  };
  { "neoclide/coc.nvim", branch = "release" };

  "lewis6991/gitsigns.nvim";

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

-- ##############
-- # navigation #
-- ##############
vim.api.nvim_set_keymap("", "<Leader>m", ":Neotree toggle<CR>", { silent = true });
vim.api.nvim_set_keymap("", "<Leader>M", ":Neotree dir=%:p:h:h reveal_file=%:p<CR>", { silent = true });
vim.api.nvim_set_keymap("", "<Leader>,", ":b#<CR>", { silent = true });

local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>F", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>.", telescope_builtin.buffers, {})
require("telescope").setup {
  pickers = {
    buffers = {
      sort_mru = true,
      mappings = {
        n = { ["d"] = "delete_buffer", },
        i = { ["<c-d>"] = "delete_buffer", }
      }
    }
  }
}

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
-- CoC
vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.CocConfirm()', { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.CocTab()', { expr = true, noremap = true, silent = true })
_G.CocTab = function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#pum#next'](1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
    return ""
  end
end

_G.CocConfirm = function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#_select_confirm']()
  else
    return vim.api.nvim_replace_termcodes("<C-g>u<CR><C-r>=coc#on_enter()<CR><C-r>=EndwiseDiscretionary()<CR>", true, true, true)
  end
end

-- Refactoring
vim.api.nvim_set_keymap("", "<Leader>d", ":CocCommand document.renameCurrentWord<CR>", { silent = true })

