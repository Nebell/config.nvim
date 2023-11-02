require('options')

-- github domain, or change it to a mirror domain
vim.g.git_src_host = "github.com"

local lazy_config = {
    defaults = {
        lazy = true,
    },
    git = {
        url_format = "https://" .. vim.g.git_src_host .. "/%s.git",
    },
    install = {
        missing = true,
    },
    change_detection = {
        notify = false, -- get a notification when changes are found
    }
}

local function lazy_setup()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://" .. vim.g.git_src_host .. "/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
    require('lazy').setup("plugins", lazy_config)
end

lazy_setup()

-- keyset
require('keyset')

-- require('autocmd')
require('utils').source_files_from_dir(vim.fn.stdpath('config') .. "/lua/autocmd")

