local keys = {
    { "<C-T>", "<CMD>ToggleTerm<CR>",            mode = { "i", "n", "v" }, { silent = true } },
    { "<C-T>", "<C-\\><C-n><CMD>ToggleTerm<CR>", mode = 't',               { silent = true } },
    { "<ESC>", "<C-\\><C-n>",                    mode = 't',               { silent = true } },
}

-- generate terminal keys
for i = 1, 9, 1 do
    keys[#keys + 1] = {
        string.format("<Leader>t%d", i),
        function() vim.cmd({ cmd = 'ToggleTerm', args = { tostring(i) } }) end,
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
        keys = keys,
    }
}
