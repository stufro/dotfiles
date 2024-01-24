vim.g.crystal_auto_format = 1;
vim.cmd("command! A CrystalSpecSwitch")
vim.api.nvim_set_keymap("", "<Leader>t", ":CrystalSpecRunCurrent<CR>", {});
vim.api.nvim_set_keymap("", "<Leader>T", ":CrystalSpecRunAll<CR>", {});
