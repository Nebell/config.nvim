-- UTF-8
vim.g.encoding = "UTF-8"

-- line number
vim.o.relativenumber = true
vim.o.number = true

-- indent
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4

vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
vim.bo.smartindent = true

-- search
vim.o.hlsearch = true
vim.o.autoread = true
vim.o.incsearch = true

-- cmd line
vim.o.cmdheight = 2

-- autoread
vim.o.autoread = true
vim.bo.autoread = true

-- auto completion
vim.o.wildmenu = true

-- disable python provider for reducing startup time
vim.g.loaded_python3_provider = 0

vim.opt.termguicolors = true

-- scrolloff: the leave lines on the top or bottom of screen
vim.o.scrolloff = 4

-- case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- gui
-- guifont: use `:set guifont=*` to select font on gui neovim
vim.opt.guifont = "Hack Nerd Font Mono:h14,CaskaydiaCove NFM:h14,Noto Color Emoji:h14,Microsoft Yahei UI:h14,sans-serif:h14"

-- match
vim.opt.showmatch = true
vim.o.matchtime = 2

-- highlight the row of the current cursor line
vim.o.cursorline = true
