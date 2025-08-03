local M = {}
local H = {} 

-- vim.api.nvim_get_option_info2(vim.opt.relativenumber, {scope = 'global' })

M.config = {
	options = {
    colorscheme  = nil,
    basic = true,
    extra_ui = false,
    win_borders = "default"
  },
  mappings = {
    basic = true,
    options_toggle_prefix = [[\]],
    windows = false,
    move_with_alt = false, 
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = false,
  }
}
setmetatable(M.config, {fuck= "fuck" })
vim.print(getmetatable(M.config))

H.apply_options = function(config)
  local o, opt = vim.o, vim.opt
  if config.options.colorscheme ==nil then
    vim.cmd.colorscheme("habamax")
  else
    vim.cmd.colorscheme(config.options.colorscheme)
  end

  -- Use `local o, opt = vim.o, vim.opt` to copy lines as is.
  -- Or use `vim.o` and `vim.opt` directly.
  if config.options.basic then
    if vim.g.mapleader == nil then
      vim.g.mapleader = " " 
      vim.g.maplocalleader = " "
    end
    vim.schedule(function()
      vim.o.clipboard = 'unnamedplus'
    end)
    opt.number = true                              -- Line numbers
    opt.relativenumber = true                      -- Relative line numbers
    opt.cursorline = true                          -- Highlight current line
    opt.wrap = false                               -- Don't wrap lines
    opt.scrolloff = 10                             -- Keep 10 lines above/below cursor 
    opt.sidescrolloff = 8                          -- Keep 8 columns left/right of cursor

    -- Indentation
    opt.tabstop = 2                                -- Tab width
    opt.shiftwidth = 2                             -- Indent width
    opt.softtabstop = 2                            -- Soft tab stop
    opt.expandtab = true                           -- Use spaces instead of tabs
    opt.smartindent = true                         -- Smart auto-indenting
    opt.autoindent = true                          -- Copy indent from current line

    -- Search settings
    opt.ignorecase = true                          -- Case insensitive search
    opt.smartcase = true                           -- Case sensitive if uppercase in search
    opt.hlsearch = false                           -- Don't highlight search results 
    opt.incsearch = true                           -- Show matches as you type

    -- Visual settings
    opt.termguicolors = true                       -- Enable 24-bit colors
    -- opt.signcolumn = "yes"                         -- Always show sign column
    --opt.colorcolumn = "100"                        -- Show column at 100 characters
    opt.showmatch = true                           -- Highlight matching brackets
    opt.matchtime = 2                              -- How long to show matching bracket
    opt.cmdheight = 1                              -- Command line height
    opt.completeopt = "menuone,noinsert,noselect"  -- Completion options 
    opt.showmode = false                           -- Don't show mode in command line 
    opt.pumheight = 10                             -- Popup menu height 
    opt.pumblend = 10                              -- Popup menu transparency 
    opt.winblend = 0                               -- Floating window transparency 
    opt.conceallevel = 0                           -- Don't hide markup 
    opt.concealcursor = ""                         -- Don't hide cursor line markup 
    opt.lazyredraw = true                          -- Don't redraw during macros
    opt.synmaxcol = 300                            -- Syntax highlighting limit 

    -- File handling
    opt.backup = false                             -- Don't create backup files
    opt.writebackup = false                        -- Don't create backup before writing
    opt.swapfile = false                           -- Don't create swap files
    opt.undofile = true                            -- Persistent undo
    opt.undodir = vim.fn.expand("~/.vim/undodir")  -- Undo directory
    opt.updatetime = 300                           -- Faster completion
    opt.timeoutlen = 500                           -- Key timeout duration
    opt.ttimeoutlen = 0                            -- Key code timeout
    opt.autoread = true                            -- Auto reload files changed outside vim
    opt.autowrite = false                          -- Don't auto save

    -- Behavior settings
    opt.hidden = true                              -- Allow hidden buffers
    opt.errorbells = false                         -- No error bells
    opt.backspace = "indent,eol,start"             -- Better backspace behavior
    opt.autochdir = false                          -- Don't auto change directory
    opt.iskeyword:append("-")                      -- Treat dash as part of word
    opt.path:append("**")                          -- include subdirectories in search
    opt.selection = "exclusive"                    -- Selection behavior
    opt.mouse = "a"                                -- Enable mouse support
    opt.clipboard:append("unnamedplus")            -- Use system clipboard
    opt.modifiable = true                          -- Allow buffer modifications
    opt.encoding = "UTF-8"                         -- Set encoding

    -- Cursor settings
    opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

    -- Folding settings
    opt.foldmethod = "expr"                             -- Use expression for folding
    opt.foldlevel = 99                                  -- Start with all folds open

    -- Split behavior
    opt.splitbelow = true                          -- Horizontal splits go below
    opt.splitright = true                          -- Vertical splits go right
  end
end

H.apply_mappings = function(config)
  local.m
  if config.mappings.basic then



  end
  end

H.apply_autocommands = function(config)
  if config.autocommands.basic then

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
  end
end

H.keymap_set = function(modes, lhs, rhs, opts)
end
H.map = function(mode, lhs, rhs, opts)
  if lhs == '' then return end
  opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)

end
M.setup = function()
  config = M.config
  H.apply_options(config)
  H.apply_autocommands(config)
end

return M
