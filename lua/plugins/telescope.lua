---------- fuzzy search -------------
return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'kdheepak/lazygit.nvim',
    },
    cmd = "Telescope",
    module_pattern = 'telescope.*',
    config = function()
        -- fuzzy search
        local mapping = {
            ["<C-j>"] = {
                require('telescope.actions').move_selection_next, type = "action",
                opts = { nowait = true, silent = true }
            },
            ["<C-k>"] = {
                require('telescope.actions').move_selection_previous, type = "action",
                opts = { nowait = true, silent = true }
            }
        }

        require('telescope').setup({
            defaults = {
                mappings = {
                    i = mapping,
                    n = mapping
                }
            },
            extensions = {
            },
        })
    end,
    keys = {
        { "<Space>t", "<CMD>Telescope<CR>",                           mode = { "n", "v" },      { silent = true } },
        { "<C-P>",    "<CMD>Telescope find_files<CR>",                mode = { "n", "v", "i" }, { silent = true } },
        { "<Space>f",    "<CMD>Telescope current_buffer_fuzzy_find<CR>", mode = { "n", "v" }, { silent = true } },
        { "<Space>j", "<CMD>Telescope jumplist<CR>",                  mode = { "n", "v" },      { silent = true } },
        { "<Space><Space>", "<CMD>Telescope buffers<CR>",                  mode = { "n", "v" },      { silent = true } },
    },
}