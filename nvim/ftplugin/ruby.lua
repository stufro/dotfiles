vim.g.rspec_command = "!bundle exec rspec {spec}"
vim.api.nvim_set_keymap("", "<Leader>t", ":call RunNearestSpec()<CR>", {});
vim.api.nvim_set_keymap("", "<Leader>T", ":call RunCurrentSpecFile()<CR>", {});
vim.api.nvim_set_keymap("", "<Leader>l", ":call RunLastSpec()<CR>", {});
vim.api.nvim_set_keymap("", "<Leader>a", ":call RunAllSpecs()<CR>", {});
-- vim.cmd("command! AC :execute \"e \" . eval('rails#buffer().alternate()')")
