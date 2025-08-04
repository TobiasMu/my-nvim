local M = {}
local H = {} 


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
  
  if config.options.statusline then

    -- Git branch function
    local function git_branch()
      local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
      if branch ~= "" then
        return "  " .. branch .. " "
      end
      return ""
    end

    -- File type with icon
    local function file_type()
      local ft = vim.bo.filetype
      local icons = {
        lua = "[LUA]",
        python = "[PY]",
        javascript = "[JS]",
        html = "[HTML]",
        css = "[CSS]",
        json = "[JSON]",
        markdown = "[MD]",
        vim = "[VIM]",
        sh = "[SH]",
      }

      if ft == "" then
        return "  "
      end

      return (icons[ft] or ft)
    end

    -- LSP status
    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        return "  LSP "
      end
      return ""
    end

    -- Word count for text files
    local function word_count()
      local ft = vim.bo.filetype
      if ft == "markdown" or ft == "text" or ft == "tex" then
        local words = vim.fn.wordcount().words
        return "  " .. words .. " words "
      end
      return ""
    end

    -- File size
    local function file_size()
      local size = vim.fn.getfsize(vim.fn.expand('%'))
      if size < 0 then return "" end
      if size < 1024 then
        return size .. "B "
      elseif size < 1024 * 1024 then
        return string.format("%.1fK", size / 1024)
      else
        return string.format("%.1fM", size / 1024 / 1024)
      end
    end

    -- Mode indicators with icons
    local function mode_icon()
      local mode = vim.fn.mode()
      local modes = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        ["\22"] = "V-BLOCK",  -- Ctrl-V
        c = "COMMAND",
        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK",  -- Ctrl-S
        R = "REPLACE",
        r = "REPLACE",
        ["!"] = "SHELL",
        t = "TERMINAL"
      }
      return modes[mode] or "  " .. mode:upper()
    end

    _G.mode_icon = mode_icon
    _G.git_branch = git_branch
    _G.file_type = file_type
    _G.file_size = file_size
    _G.lsp_status = lsp_status

    vim.cmd([[
      highlight StatusLineBold gui=bold cterm=bold
    ]])

    -- Function to change statusline based on window focus
    local function setup_dynamic_statusline()
      vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
        callback = function()
        vim.opt_local.statusline = table.concat {
          "  ",
          "%#StatusLineBold#",
          "%{v:lua.mode_icon()}",
          "%#StatusLine#",
          " │ %f %h%m%r",
          "%{v:lua.git_branch()}",
          " │ ",
          "%{v:lua.file_type()}",
          " | ",
          "%{v:lua.file_size()}",
          " | ",
          "%{v:lua.lsp_status()}",
          "%=",                     -- Right-align everything after this
          "%l:%c  %P ",             -- Line:Column and Percentage
        }
        end
      })
      vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

      vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
        callback = function()
          vim.opt_local.statusline = "  %f %h%m%r │ %{v:lua.file_type()} | %=  %l:%c   %P "
        end
      })
    end

    setup_dynamic_statusline()
  end




end

H.apply_mappings = function(config)
  local map = vim.keymap.set
  if config.mappings.basic then
    map("n", "<leader>xx", ":so<CR>", {desc=""})
    map("n", "<leader>xx", ":so<CR>", {desc=""})
    -- better up and down
    map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })


    map('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
    map('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")
    map('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, replace_keycodes = false, desc = 'Visually select changed text' })

  end

  if config.mappings.windows then
    -- Window navigation
    map('n', '<C-H>', '<C-w>h', { desc = 'Focus on left window' })
    map('n', '<C-J>', '<C-w>j', { desc = 'Focus on below window' })
    map('n', '<C-K>', '<C-w>k', { desc = 'Focus on above window' })
    map('n', '<C-L>', '<C-w>l', { desc = 'Focus on right window' })
  end

  if config.mappings.lua_dev then
    
    map("n", "<leader>xx", ":so<cr>")
    map("n", "<leader>xl", ":.lua<cr>")

  end 

  if config.mappings.vanilla_sugar then
 -- Normal mode mappings

-- Center screen when jumping
    map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
    map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
    map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
    map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })   

    map("n", "-", ":e .<cr>")
    --cheap mini ai
    map("n", "ciq", [[f"vi"c]])
    --copy full path
    map("n", "<leader>pa", function()
      local path = vim.fn.expand("%:p")
      vim.fn.setreg("+", path)
      print("file:", path)
    end)

    -- Move lines up/down
    map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
    map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
    map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
    map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

    -- Better indenting in visual mode
    map("v", "<", "<gv", { desc = "Indent left and reselect" })
    map("v", ">", ">gv", { desc = "Indent right and reselect" })

    -- Quick file navigation
    map("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
    map("n", "<leader>ff", ":find ", { desc = "Find file" })

    -- Better J behavior
    map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
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

H.find_ai = function(line,target,csr_x)
  t = {
    ["quote"] = {'"', "'"},
    ["bracket"] = {"%(","%[","%{","%<"},
    pairs = {
      ["("] = ")",
      ["["] = "]",
      ["{"] = "}",
      ["<"] = ">",
    }
  }
  if t[target] ~=nil then
    match = nil
    for _, val in ipairs(t[target]) do
      vim.print(i,val)
      s, e = string.find(line,val,csr_x)
      if s ~= nil and match == nil then
        match = s 
      elseif s ~= nil and match ~=nil then
        match = math.min(s, match)
      end
    end
    target = string.sub(line,match,match)
    return target, match
  else
    vim.print("no match")
  end
end


-- @params mode can be c y and d
-- @params target can be 'quotes', 'brackets' etc. 
-- @params ai can be around or inside
M.my_ai = function(mode,ai,target)
local bufnr = vim.api.nvim_get_current_buf()
local filename = vim.api.nvim_buf_get_name(bufnr)
local csr = vim.api.nvim_win_get_cursor(0)
local line = vim.api.nvim_get_current_line()



-- local s,e = string.find(line, target ,csr[2]+2 )
target, pos = H.find_ai(line, target, csr[2])


vim.api.nvim_win_set_cursor(0, {csr[1], s-1})

vim.api.nvim_feedkeys('v'..ai..target..mode, 'n', false)

-- local lines = vim.api.nvim_buf_get_lines(bufnr,csr[1] , -1, false)
-- local content = table.concat(lines, '\n')
vim.print(bufnr, filename, csr, s,e)

end
M.setup = function(config)
  if config == {} then config = M.config end
  H.apply_options(config)
  H.apply_autocommands(config)
  H.apply_mappings(config)
end

return M
