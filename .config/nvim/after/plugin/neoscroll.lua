local neoscroll = require('neoscroll')
neoscroll.setup({
    easing = 'quadratic',
    mappings = {
    },
})

local keymap = {
    ['<C-u>'] = function() neoscroll.ctrl_u({ duration = 125 }) end,
    ['<C-d>'] = function() neoscroll.ctrl_d({ duration = 125 }) end,
    ['<C-b>'] = function() neoscroll.ctrl_b({ duration = 200 }) end,
    ['<C-f>'] = function() neoscroll.ctrl_f({ duration = 200 }) end,
    ['zt']    = function() neoscroll.zt({ half_win_duration = 125 }) end,
    ['zz']    = function() neoscroll.zz({ half_win_duration = 125 }) end,
    ['zb']    = function() neoscroll.zb({ half_win_duration = 125 }) end,
}
for key, func in pairs(keymap) do
    vim.keymap.set({ 'n', 'v', 'x' }, key, func)
end
