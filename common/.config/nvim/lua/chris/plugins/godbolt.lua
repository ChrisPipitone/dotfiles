return {
	"p00f/godbolt.nvim",
	ft = { "c", "cpp" },
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>Ga", "<cmd>Godbolt<CR>",             mode = { "n", "v" }, desc = "ASM view" },
		{ "<leader>Gc", "<cmd>GodboltCompiler telescope<CR>", mode = "n",   desc = "Select compiler" },
	},
	opts = {
		languages = {
			cpp = { compiler = "clang_trunk", options = "-O2 -std=c++17" },
			c   = { compiler = "clang_trunk", options = "-O2" },
		},
		quickfix = {
			enable = true,
			auto_open = true,
		},
		url = "https://godbolt.org",
	},
}
