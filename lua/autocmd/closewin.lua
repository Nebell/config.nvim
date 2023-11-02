-- auto close windows which filetype are in the ignore filetypes
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local invalid_win = {}
        local ignore_ft = require("common").ignore_ft

        local current_buf_ft = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'filetype')
        local wins = vim.api.nvim_list_wins()
        local wins_info = {}
        for _, ft in ipairs(ignore_ft) do
            -- do nothing if exit the windows of ignore filetype
            if current_buf_ft == ft then
                return
            end

            for _, w in ipairs(wins) do
                if wins_info[w] == nil then
                    local buf_id = vim.api.nvim_win_get_buf(w)
                    wins_info[w] = vim.api.nvim_buf_get_option(buf_id, 'filetype')
                end

                -- record the window
                if wins_info[w] == ft then
                    table.insert(invalid_win, w)
                end
            end
        end

        if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
        end
    end
})

