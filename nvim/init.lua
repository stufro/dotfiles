-- mappings
vim.g.mapleader = ",";

-- set tab to be 2 spaces
vim.opt.shiftwidth = 2

-- ###############
-- # pckr config #
-- ###############
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/lewis6991/pckr.nvim",
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()
require("pckr").add{
  -- syntax + language support
  "rstacruz/vim-closer";
  "vim-crystal/vim-crystal";
  { "neoclide/coc.nvim", branch = "release" };

  "lewis6991/gitsigns.nvim";

  -- appearance
  "gmr458/vscode_modern_theme.nvim";
  { "nvimdev/dashboard-nvim",
    event = "VimEnter",
    requires = { "nvim-tree/nvim-web-devicons" }
  };

  -- navigation
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
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

require("dashboard").setup();

vim.cmd("set number")

-- ##############
-- # navigation #
-- ##############
vim.api.nvim_set_keymap("", "<Leader>m", ":Neotree toggle<CR>", { silent = true });
vim.api.nvim_set_keymap("", "<Leader>M", ":Neotree dir=%:p:h:h reveal_file=%:p<CR>", { silent = true });
vim.api.nvim_set_keymap("", "<Leader>,", ":b#<CR>", { silent = true });

local telescope_builtin = require("telescope.builtin")
vim.api.nvim_set_keymap("", "<Leader>f", "<CMD>lua require'telescope-config'.project_files()<CR>", { noremap = true, silent = true });
vim.keymap.set("n", "<leader>g", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>.", telescope_builtin.buffers, {})

-- ###################
-- # gitsigns config #
-- ###################
require("gitsigns").setup {
  signs = {
    add = { text = "+" }
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 300,
  },
}
vim.cmd("highlight GitSignsAdd guifg=Green")
vim.cmd("highlight GitSignsChange guifg=#004acc")
vim.cmd("highlight GitSignsDelete guifg=DarkRed")
vim.cmd("highlight GitSignsCurrentLineBlame guifg=#555555")

-- #############################
-- # syntax + language support #
-- #############################
-- Crystal
vim.g.crystal_auto_format = 1;
vim.api.nvim_set_keymap("", "<Leader>A", ":CrystalSpecSwitch<CR>", { silent = true });
vim.api.nvim_set_keymap("", "<Leader>t", ":CrystalSpecRunCurrent<CR>", {});
vim.api.nvim_set_keymap("", "<Leader>T", ":CrystalSpecRunAll<CR>", {});

-- CoC
vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.CocConfirm()', { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.CocTab()', { expr = true, noremap = true, silent = true })
_G.CocTab = function()
  if vim.fn['coc#pum#visible']() == 1 then
    vim.fn['coc#pum#next'](1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
    return ""
  end
end

_G.CocConfirm = function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#_select_confirm']()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', false)
    return ""
  end
end