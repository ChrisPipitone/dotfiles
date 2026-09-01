return {
	"p00f/clangd_extensions.nvim",
	ft = { "c", "cpp", "objc", "objcpp" },
	opts = {
		ast = {
			role_icons = {
				type = "",
				declaration = "",
				expression = "",
				specifier = "",
				statement = "",
				["template argument"] = "",
			},
		},
	},
	keys = {
		{
			"<leader>cA",
			"<cmd>ClangdAST<CR>",
			ft = { "c", "cpp" },
			desc = "AST viewer",
		},
		{
			"<leader>cM",
			"<cmd>ClangdMemoryUsage<CR>",
			ft = { "c", "cpp" },
			desc = "Memory layout",
		},
		{
			"<leader>cT",
			"<cmd>ClangdTypeHierarchy<CR>",
			ft = { "c", "cpp" },
			desc = "Type hierarchy",
		},
	},
}
