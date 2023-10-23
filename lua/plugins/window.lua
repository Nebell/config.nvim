return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    -- event = 'VeryLazy',
    version = '2.*',
    config = function()
        require 'window-picker'.setup()
    end,
    keys = {
        {
            "gw",
            function()
                local target_window_id = require('window-picker').pick_window(--[[ { hint = 'floating-big-letter' } ]])
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
