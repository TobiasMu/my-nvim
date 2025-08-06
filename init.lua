require("lsp")
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
    my_ai = true,
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = false,
  }
  })
vim.lsp.enable({"lua_ls"})

-- vim.lsp.diagnostic()

vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config })
end, { desc = 'Toggle diagnostic virtual_text' })

