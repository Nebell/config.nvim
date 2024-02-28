local M = {}

-- language servers
local servers = {
    -- pip install "python-lsp-server[all]"
    pylsp = {
        plugins = {
            pylint = {
                enabled = false,
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim', 'require' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = { vim.env.VIMRUNTIME },
                    -- Disable the message asks to modify .luarc.json
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    rust_analyzer = {},
    gopls = {},
    hls = { filetypes = { 'haskell', 'lhaskell', 'cabal' } },
    racket_langserver = {},
    zls = {},
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    if client.server_capabilities.documentSymbolProvider then
        local navic = require("nvim-navic")
        navic.attach(client, bufnr)
    end
end

-- setup lspconfig and plugins
function M.setup()
    -- utils.async_run(mason_setup)
    require('lsp.keybinding').keybinding()

    local lsp = require('lspconfig')
    local cmp = require('cmp_nvim_lsp')
    local capabilities
    if cmp ~= nil then
        capabilities = cmp.default_capabilities()
    end
    for srv, cfg in pairs(servers) do
        if cfg.on_attach == nil then
            cfg.on_attach = on_attach
        end

        -- nvim-cmp
        cfg.capabilities = capabilities

        if lsp[srv] ~= nil then
            lsp[srv].setup(cfg)
        end
    end

    require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities
            }
        end,

    }
end

return M
