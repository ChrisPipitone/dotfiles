-- Plugin set for vscode-neovim only. Loaded from lazy.lua when vim.g.vscode is
-- set. Deliberately outside lua/chris/plugins/ so the normal `{ import =
-- "chris.plugins" }` can never pick it up.
--
-- Motions and text objects only. VSCode owns LSP, completion, diagnostics,
-- formatting, file tree, statusline, git signs and debugging.

return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash treesitter search" },
		},
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		version = "*",
		config = true,
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			-- No ts_context_commentstring pre_hook here: it needs treesitter
			-- parsers that this stripped-down path does not install.
			require("Comment").setup()
		end,
	},

	-- matches the terminal config's spec in plugins/mini.lua
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = { n_lines = 500 },
	},
}
