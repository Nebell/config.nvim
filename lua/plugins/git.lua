---------- git signs for buffer -------------
return {
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('gitsigns').setup() end,
        event = "BufReadPost",
        keys = {
            { "<Leader>bl", "<cmd>Gitsigns toggle_current_line_blame<CR>", { 'n', 'v' },
                { silent = true, noremap = true } },
        },
    },

    ---------- git ------------------
    {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'Gvdiffsplit', 'Ggrep' },
        init = function()
            -- close via shortkey 'q'
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { 'fugitiveblame' },
                callback = function(ev)
                    vim.api.nvim_buf_set_keymap(0, 'n', 'q', "<CMD>quit<CR>", { noremap = true, silent = true })
                end
            })
        end,
        keys = {
            { 'gl', function()
                vim.cmd("Git blame")
            end },
        },
    },

    ---------- git diff -------------
    {
        'sindrets/diffview.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        cmd = { "DiffviewOpen" },
    },

    ---------- git branchs ----------
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim",        -- optional
            "ibhagwan/fzf-lua",              -- optional
        },
        config = true,
        cmd = "Neogit",
        keys = {
            { "gv", function() require('neogit').open({ kind = "auto" }) end, { 'n', 'v' },
                {
                    slient = true,
                    noremap = true
                } },
            { "gm", function() require('neogit').open({ "commit" }) end, { 'n', 'v' },
                {
                    slient = true,
                    noremap = true
                } },
        }
    }
}
