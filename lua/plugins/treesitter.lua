---------- highlight and code structure -------------

-- config
local treesitter_config = {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = { "lua", "go", "python", "markdown", "markdown_inline" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = {},
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        disable = function(_, buf)
            local max_filesize = 100 * 1024 * 1024     -- 100 MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
            scope_incremental = '<TAB>',
        }
    },
}

local function setup()
    -- use global github proxy
    for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
        config.install_info.url = config.install_info.url:gsub("https://github.com/",
        "https://" .. vim.g.git_src_host .. "/")
    end

    require('utils').async_run(function()

        -- compilers
        local compilers = { vim.fn.getenv('CC'), "cc", "gcc", "clang", "cl", "zig" }
        if vim.fn.has('win32') then
            compilers = { "zig", "clang", vim.fn.getenv('CC'), "gcc" }
        end

        require("nvim-treesitter.install").prefer_git = true
        require 'nvim-treesitter.install'.compilers = compilers
        require('nvim-treesitter.configs').setup(treesitter_config)
    end)
end


return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = "BufReadPost",
        build = ":TSUpdate",
        config = setup
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = "BufReadPost",
        dependencies = 'nvim-treesitter',
        config = function()
            require('utils').async_run(
                require('treesitter-context').setup)
        end
    },
}
