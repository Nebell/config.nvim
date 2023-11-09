---------- autocompletion -------------
local function add_snippets()
    local ls = require('luasnip')
    local s = ls.snippet
    local t = ls.text_node

    ls.add_snippets("all", {
        -- lambda symbol
        s(":lambda", { t('λ') }),
    })

    ls.add_snippets("php", {
        -- arrow
        s("-", { t('->') }),
        s("=", { t('=>') }),
    })
end

local function setup()
    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local cmp = require('cmp')
    local luasnip = require("luasnip")

    -- vscode like completion
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            -- ['<C-Space>'] = cmp.mapping.complete(),
            ['<ESC>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.abort()
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
            ['<CR>']  = cmp.mapping(function(fallback)
                local entry = cmp.get_selected_entry()
                if not entry then
                    fallback()
                else
                    cmp.confirm()
                end
            end),
            ["<Tab>"] = cmp.mapping(function(fallback)
                -- This little snippet will confirm with tab, and if no entry is selected,
                -- will confirm the first item
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    if not entry then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        cmp.mapping.confirm({ select = true })
                    else
                        cmp.confirm()
                    end
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s", "c", }),
            ['<C-K>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c", }),
            ['<C-J>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s", "c", }),
            -- Abort completion and quit insert mode
            -- 'C' means cancel
            ['<C-C>'] = cmp.mapping(function(fallback)
                cmp.close()
                if cmp.visible() then
                    vim.cmd("stopinsert")
                else
                    fallback()
                end
            end, { "i" })
        }),
        -- sources of completion
        sources = cmp.config.sources({
            {
                name = 'omni',
                option = {
                    disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
                }
            },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'treesitter' },
            { name = 'path' },
            { name = 'buffer' },
        })
    })

    -- Set configuration for specific filetype.
    -- cmp.setup.filetype()

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })

    -- cmp.event:on('confirm_done', reuqire('nvim-autopairs.completion.cmp').on_confirm_done())
    add_snippets()
end

local codeium_toggler = require('utils').toggler(function()
    vim.cmd("CodeiumEnable")
end, function()
    vim.cmd("CodeiumDisable")
end)

return {
    ----------- autopairs ---------------
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            local Rule = require('nvim-autopairs.rule')
            local cond = require('nvim-autopairs.conds')
            npairs.setup({})

            npairs.add_rules({
                Rule("(", ")", { "racket", "scheme" })
                    :with_move(cond.none())
            })
        end
    },

    ----------- nvim-cmp ---------------
    {
        'hrsh7th/nvim-cmp',
        event = "VeryLazy",
        module = { 'cmp_nvim_lsp', 'cmp' },
        config = setup,
        -- nvim-cmp plugins, run dependenciesnvim-cmp
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
    },
    {
        'hrsh7th/cmp-buffer',
        event = "BufReadPost",
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
    },
    {
        'ray-x/cmp-treesitter',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        event = "LspAttach",
        dependencies = {
            'hrsh7th/nvim-cmp',
            'neovim/nvim-lspconfig',
        },
    },
    {
        'hrsh7th/cmp-nvim-lua',
        dependencies = 'hrsh7th/nvim-cmp',
        event = "InsertEnter",
    },
    {
        'hrsh7th/cmp-omni',
        ft = "lua",
        dependencies = 'hrsh7th/nvim-cmp',
    },

    --------------------- ai -------------------------
    {
        'Exafunction/codeium.vim',
        -- event = 'BufEnter',
        config = function()
            vim.g.codeium_enabled = 0
            vim.g.codeium_disable_bindings = 1

            vim.keymap.set('i', '<m-i>', function() return vim.fn['codeium#Accept']() end, { silent = true, expr = true })
            vim.keymap.set('i', '<m-j>', function() return vim.fn['codeium#CycleCompletions'](1) end, { silent = true, expr = true })
            vim.keymap.set('i', '<m-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { silent = true, expr = true })
            vim.keymap.set('i', '<m-o>', function() return vim.fn['codeium#Clear']() end, { silent = true, expr = true })
        end,
        keys = {
            { '<Leader>ai', function() codeium_toggler:toggle() end, { 'n', 'v' }, { expr = true } },
        }
    },
}
