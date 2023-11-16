local toggleterm_config = {
    term_num = 1
}

function toggleterm_config.switch_prev()
    if toggleterm_config.term_num <= 1 then
        return
    end

    toggleterm_config.term_num = toggleterm_config.term_num - 1
    vim.cmd({ cmd = 'ToggleTerm', args = { tostring(toggleterm_config.term_num) } })
end

function toggleterm_config.switch_next()
    if toggleterm_config.term_num >= 9 then
        return
    end

    toggleterm_config.term_num = toggleterm_config.term_num + 1
    vim.cmd({ cmd = 'ToggleTerm', args = { tostring(toggleterm_config.term_num) } })
end

-- setup autocmd to make key bindings
function toggleterm_config.setup_autocmd(self)
    -- setup autocmd
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "toggleterm",
        callback = function()
            local opts = { silent = true, noremap = true, buffer = true }
            vim.keymap.set({ 'n', 'v', 't' }, '<C-h>', toggleterm_config.switch_prev, opts)
            vim.keymap.set({ 'n', 'v', 't' }, '<C-l>', toggleterm_config.switch_next, opts)
        end,
    })
end

local keys = {
    { "<C-T>", "<CMD>ToggleTerm<CR>",            mode = { "i", "n", "v" }, { silent = true } },
    { "<C-T>", "<C-\\><C-n><CMD>ToggleTerm<CR>", mode = 't',               { silent = true } },
    { "<ESC>", "<C-\\><C-n>",                    mode = 't',               { silent = true } },
}

-- generate terminal keys
for i = 1, 9, 1 do
    keys[#keys + 1] = {
        string.format("<M-%d>", i),
        function()
            -- store the number of term
            toggleterm_config.term_num = i

            -- switch terminal
            vim.cmd({ cmd = 'ToggleTerm', args = { tostring(i) } })
        end,
        mode = { 'n', 'v' },
        { silent = true },
        desc = string.format("Terminal [%d]", i)
    }
end

return {
    {
        ---------- terminal -------------
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            direction = "float",
            start_in_insert = false,
            autochdir = true,
        },
        init = function()
            toggleterm_config.setup_autocmd()
        end,
        keys = keys,
    }
}

