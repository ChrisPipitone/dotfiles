local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Inside vscode-neovim the editor owns UI, LSP, completion and debugging.
-- Loading the full spec there fights VSCode's own providers, so that path gets
-- a motion-only set. Terminal nvim (omarchy, mac, WSL) is unaffected.
if vim.g.vscode then
	require("lazy").setup({ { import = "chris.vscode" } }, {
		change_detection = { notify = false },
	})
	return
end

require("lazy").setup({
	{ import = "chris.plugins" },
	{ import = "chris.plugins.lsp" },
	-- install = { colorscheme = { "onehalf" } },
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
