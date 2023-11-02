local M = {}

function M.lspsaga()
    local keyset = vim.keymap.set

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true }
    -- keyset('n', 'gD', vim.lsp.buf.declaration, bufopts)
    keyset('n', 'gd', "<cmd>Lspsaga goto_definition<CR>", bufopts)
    keyset('n', 'gr', "<cmd>Lspsaga finder<CR>", bufopts)
    keyset('n', 'gi', "<cmd>Lspsaga finder<CR>", bufopts)
    -- keyset('n', 'gf', function() vim.lsp.buf.format { async = true } end, bufopts)
    keyset('n', 'K', "<cmd>Lspsaga hover_doc<CR>", bufopts)
    keyset('n', 'gK', "<cmd>Lspsaga hover_doc ++keep<CR>", bufopts)
    keyset('n', '<Leader>rn', "<cmd>Lspsaga rename<CR>", bufopts)
    keyset('n', '<Leader>ca', "<cmd>Lspsaga code_action<CR>", bufopts)
    keyset("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    keyset("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

    -- local opts = { noremap = true, silent = true }
    -- keyset('n', '<Leader>d', "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
    -- keyset('n', 'gp', function()
    --     require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    -- end, opts)
    -- keyset('n', 'gn', function()
    --     require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    -- end, opts)
    -- keyset('n', '<Leader>q', "<cmd>Lspsaga show_buf_diagnostics<CR>", opts)
end

function M.default()

    local utils = require('utils')
    local keyset = vim.keymap.set

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true }
    keyset('n', 'gD', vim.lsp.buf.declaration, bufopts)
    keyset('n', 'gd', vim.lsp.buf.definition, bufopts)
    keyset('n', 'gr', vim.lsp.buf.references, bufopts)
    keyset('n', 'gi', vim.lsp.buf.implementation, bufopts)
    keyset('n', 'gf', function() vim.lsp.buf.format { async = true } end, bufopts)
    keyset('n', 'K', utils.async(vim.lsp.buf.hover), bufopts)
    keyset('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
    keyset('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)

    local opts = { noremap = true, silent = true }
    keyset('n', '<Leader>d', vim.diagnostic.open_float, opts)
    keyset('n', 'gp', vim.diagnostic.goto_prev, opts)
    keyset('n', 'gn', vim.diagnostic.goto_next, opts)
    keyset('n', '<Leader>q', vim.diagnostic.setloclist, opts)
end

function M.keybinding()
    if vim.cmd.Lspsaga ~= nil then
        M.lspsaga()
    else
        M.default()
    end
end

return M
