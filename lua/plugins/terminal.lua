local toggleterm_config = {
    term_num = 0
}

function toggleterm_config.switch_prev()
    if toggleterm_config.term_num <= 0 then
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

function toggleterm_config.setup_autocmd(self)
    local opts = { silent = true, noremap = true }
    -- vim.api.nvim_buf_set_keymap(0, 'n', '<C-h>', toggleterm_config.switch_prev, opts)
    -- vim.api.nvim_buf_set_keymap(0, 'n', '<C-l>', toggleterm_config.switch_next, opts)
end

local keys = {
    { "<C-T>",     "<CMD>ToggleTerm<CR>",            mode = { "i", "n", "v" }, { silent = true } },
    { "<C-T>",     "<C-\\><C-n><CMD>ToggleTerm<CR>", mode = 't',               { silent = true } },
    { "<ESC>",     "<C-\\><C-n>",                    mode = 't',               { silent = true } },

    -- previous console
    { "<Space>cp", toggleterm_config.switch_prev,    mode = { 'n' },           { silent = true, noremap = true }, desc = "switch previous console" },

    -- next console
    { "<Space>cn", toggleterm_config.switch_next,    mode = { 'n', },          { silent = true, noremap = true }, desc = "switch next console" }
}

-- generate terminal keys
for i = 1, 9, 1 do
    keys[#keys + 1] = {
        string.format("<Space>c%d", i),
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
        },
        init = function()
            toggleterm_config.setup_autocmd()
        end,
        keys = keys,
    }
}
