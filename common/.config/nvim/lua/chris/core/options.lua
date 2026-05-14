local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8

-- editing
opt.backspace = "indent,eol,start"
opt.iskeyword:append("-")

-- clipboard: sync with system clipboard; skip on SSH where it's unavailable
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- session persistence
opt.sessionoptions:append("localoptions")

-- splits
opt.splitright = true
opt.splitbelow = true

-- performance / responsiveness
opt.updatetime = 200
opt.timeoutlen = 500

-- persistent undo across sessions
opt.undofile = true
