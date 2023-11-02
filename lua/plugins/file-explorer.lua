vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function nvim_tree_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<C-u>', api.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', '<C-k>', "15k", opts('Fallback'))
end

local function setup()
    require("nvim-tree").setup({
        on_attach = nvim_tree_on_attach,
        sync_root_with_cwd = true,
        respect_buf_cwd = false,
        prefer_startup_root = true,
        reload_on_bufenter = true,
        update_focused_file = {
            enable = true,
            update_root = false
        },
        view = {
            width = 30,
        },
        filters = {
            git_ignored = false,
            dotfiles = false,
            git_clean = false,
            no_buffer = false,
            custom = {},
            exclude = {},
        },
    })
end

-- auto close
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#ppwwyyxx
-- vim.api.nvim_create_autocmd("QuitPre", {
--     callback = function()
--         local invalid_win = {}
--         local wins = vim.api.nvim_list_wins()
--         for _, w in ipairs(wins) do
--             local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
--             if bufname:match("NvimTree_") ~= nil then
--                 table.insert(invalid_win, w)
--             end
--         end
--         if #invalid_win == #wins - 1 then
--             -- Should quit, so we close all invalid windows.
--             for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
--         end
--     end
-- })
--

---------- file explorer -------------
return {
    'nvim-tree/nvim-tree.lua',
    cmd = "NvimTreeToggle",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = setup,
    keys = {
        { "<C-G>",       "<CMD>NvimTreeToggle<CR>",   mode = { "n", "i", "v" }, { silent = true } },
        { "<Leader>loc", "<CMD>NvimTreeFindFile<CR>", mode = { "n", "v" },      { silent = true } },
    }
}
