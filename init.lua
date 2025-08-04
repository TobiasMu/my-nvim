require("m.basic").setup({options = {
    colorscheme  = nil,
    basic = true,
    statusline=true, -- https://github.com/radleylewis/nvim-lite/blob/youtube_demo/init.lua
    extra_ui = false,
    win_borders = "default"
  },
  mappings = {
    basic = true,
    options_toggle_prefix = [[\]],
    windows = true,
    lua_dev = true,
    vanilla_sugar = true,
    move_with_alt = false, 
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = false,
  }
  })
  --todo
  --handle empty brackets/quotes
  --keymappings
vim.keymap.set("n", "<leader>tt", function()
 require('m.basic').my_ai('c', 'a',"bracket")

end)

