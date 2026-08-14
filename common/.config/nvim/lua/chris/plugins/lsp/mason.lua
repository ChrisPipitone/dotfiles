return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- biome is deliberately absent: mason's npm install-strategy=shallow
			-- skips the @biomejs/cli-<platform> optional dep, producing a shim
			-- that cannot resolve its binary. Installed via mise instead
			-- (`mise use -g npm:@biomejs/biome`); conform and the LSP both find
			-- it on PATH, and prefer a project's node_modules copy when present.
			ensure_installed = {
				"ts_ls",
				"html",
				"tailwindcss",
				"pyright",
				"ruff",
				"clangd",
				"codelldb",
				"neocmake",
				"dockerls",
				"lua_ls",
				"emmet_ls",
			},
			-- lspconfig.lua handles server setup manually via vim.lsp.enable()
			automatic_enable = false,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"ruff",
				"eslint_d",
				"clang-format",
			},
		})
	end,
}
