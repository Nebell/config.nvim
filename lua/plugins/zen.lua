-- typewriter mode
local typewriter = {
    preserve_scrolloff = vim.o.scrolloff,
    toggled = false,
}

function typewriter.toggle()
    if not typewriter.toggled then
        typewriter.preserve_scrolloff = vim.o.scrolloff
        vim.o.scrolloff = 999
    else
        vim.o.scrolloff = typewriter.preserve_scrolloff
    end
    typewriter.toggled = not typewriter.toggled
end

-- twilight
local twilight_config = {
    dimming = {
        alpha = 0.5, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = { "Normal", "#ffffff" },
        term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        inactive = false,    -- when true, other windows will be fully dimmed (unless they contain the same buffer)
    },
    context = 10,            -- amount of lines we will try to show around the current line
    treesitter = true,       -- use treesitter when available for the filetype
    -- treesitter is used to automatically expand the visible text,
    -- but you can further control the types of nodes that should always be fully expanded
    expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
        "function",
        "method",
        "table",
        "if_statement",
    },
    exclude = require("common").ignore_ft, -- exclude these filetypes
}


-- True-Zen
local true_zen_config = {
    modes = {
        -- configurations per mode
        ataraxis = {
            shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
            backdrop = 0,   -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
            minimum_writing_area = {
                -- minimum size of main window
                width = 70,
                height = 44,
            },
            quit_untoggles = false, -- type :q or :qa to quit Ataraxis mode
            padding = {
                -- padding windows
                left = 30,
                right = 30,
                top = 40,
                bottom = 40,
            },
            callbacks = {
                -- run functions when opening/closing Ataraxis mode
                open_pre = nil,
                open_pos = typewriter.toggle,
                close_pre = nil,
                close_pos = typewriter.toggle,
            },
        },
        minimalist = {
            ignored_buf_types = { "nofile" }, -- save current options from any window except ones displaying these kinds of buffers
            options = {
                -- options to be disabled when entering Minimalist mode
                number = false,
                relativenumber = false,
                showtabline = 0,
                signcolumn = "no",
                statusline = "",
                cmdheight = 1,
                laststatus = 0,
                showcmd = false,
                showmode = false,
                ruler = false,
                numberwidth = 1
            },
            callbacks = {
                -- run functions when opening/closing Minimalist mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
            },
        },
        narrow = {
            --- change the style of the fold lines. Set it to:
            --- `informative`: to get nice pre-baked folds
            --- `invisible`: hide them
            --- function() end: pass a custom func with your fold lines. See :h foldtext
            folds_style = "informative",
            run_ataraxis = true, -- display narrowed text in a Ataraxis session
            callbacks = {
                -- run functions when opening/closing Narrow mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
            },
        },
        focus = {
            callbacks = {
                -- run functions when opening/closing Focus mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
            },
        }
    },
    integrations = {
        tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
        kitty = {
            -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
            enabled = false,
            font = "+3"
        },
        twilight = true, -- enable twilight (ataraxis)
        lualine = true   -- hide nvim-lualine (ataraxis)
    },
}

return {
    {
        "folke/twilight.nvim",
        opts = twilight_config,
    },
    {
        "Pocco81/true-zen.nvim",
        keys = {
            { "<leader>zn", "<CMD>TZAtaraxis<CR>", { mode = { 'n', 'v' } } }
        },
        config = function()
            require("true-zen").setup(true_zen_config)
        end
    }
}
