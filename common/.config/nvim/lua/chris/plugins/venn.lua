-- ASCII diagram drawing. Toggle with <leader>v.
-- When active: H/J/K/L draw lines, v-select + f draws a box.
return {
	"jbyuki/venn.nvim",
	keys = { { "<leader>v", desc = "Toggle venn drawing mode" } },
	config = function()
		vim.keymap.set("n", "<leader>v", function()
			if vim.b.venn_enabled then
				vim.b.venn_enabled = nil
				vim.cmd("setlocal ve=")
				vim.api.nvim_buf_del_keymap(0, "n", "J")
				vim.api.nvim_buf_del_keymap(0, "n", "K")
				vim.api.nvim_buf_del_keymap(0, "n", "L")
				vim.api.nvim_buf_del_keymap(0, "n", "H")
				vim.api.nvim_buf_del_keymap(0, "v", "f")
			else
				vim.b.venn_enabled = true
				vim.cmd("setlocal ve=all")
				vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
			end
		end, { desc = "Toggle venn drawing mode" })
	end,
}
