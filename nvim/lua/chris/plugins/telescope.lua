return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		-- local trouble = require("trouble")
		-- local trouble_telescope = require("trouble.sources.telescope").open()
		-- -- or create your custom action
		-- local custom_actions = transform_mod({
		-- 	open_trouble_qflist = function(prompt_bufnr)
		-- 		trouble.toggle("quickfix")
		-- 	end,
		-- })

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						-- 			["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						-- ["<C-t>"] = trouble_telescope.smart_open_with_trouble,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set(
			"n",
			"<leader>ff",
			"<cmd>Telescope find_files hidden=true <cr>",
			{ desc = "Fuzzy find files in cwd" }
		)
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set(
			"n",
			"<leader>fb",
			"<cmd>Telescope buffers<cr>",
			{ desc = "list open buffers in current neovim instance" }
		)
	end,
}
