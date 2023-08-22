-- auto imports
vim.api.nvim_create_autocmd('BufWritePre', {
    desc = "auto imports",
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end
})
