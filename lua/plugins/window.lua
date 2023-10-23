return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    -- event = 'VeryLazy',
    version = '2.*',
    config = function()
        local bg_color = '#42A5F5'
        require 'window-picker'.setup({
            -- whether to show 'Pick window:' prompt
            show_prompt = false,

            -- prompt message to show to get the user input
            prompt_message = 'Pick window: ',

            highlights = {
                statusline = {
                    focused = {
                        fg = '#ededed',
                        bg = '#e35e4f',
                        bold = true,
                    },
                    unfocused = {
                        fg = '#ededed',
                        bg = bg_color,
                        bold = true,
                    },
                },
                winbar = {
                    focused = {
                        fg = '#ededed',
                        bg = '#e35e4f',
                        bold = true,
                    },
                    unfocused = {
                        fg = '#ededed',
                        bg = bg_color,
                        bold = true,
                    },
                },
            },
        })
    end,
    keys = {
        {
            "gw",
            function()
                local target_window_id = require('window-picker').pick_window( --[[ { hint = 'floating-big-letter' } ]])
                if not target_window_id then
                    return
                end

                vim.fn.win_gotoid(target_window_id)
            end,
            { 'n',           'v' },
            { slient = true, noremap = true },
            desc = "switch window"
        }
    }
}
