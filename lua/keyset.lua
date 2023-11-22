local keymap = vim.keymap.set

local opts = { silent = true, noremap = true }
keymap({ "n", "v" }, "<C-K>", "15k", opts)
keymap({ "n", "v" }, "<C-J>", "15j", opts)
