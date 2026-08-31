return {
	"Civitasv/cmake-tools.nvim",
	ft = { "c", "cpp", "cmake" },
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>Cg", "<cmd>CMakeGenerate<CR>",      desc = "Generate" },
		{ "<leader>Cb", "<cmd>CMakeBuild<CR>",         desc = "Build" },
		{ "<leader>Cr", "<cmd>CMakeRun<CR>",           desc = "Run" },
		{ "<leader>Cd", "<cmd>CMakeDebug<CR>",         desc = "Debug" },
		{ "<leader>Ct", "<cmd>CMakeSelectBuildTarget<CR>", desc = "Select target" },
		{ "<leader>Ck", "<cmd>CMakeSelectKit<CR>",     desc = "Select kit" },
		{ "<leader>Cc", "<cmd>CMakeClean<CR>",         desc = "Clean" },
		{ "<leader>Cs", "<cmd>CMakeStop<CR>",          desc = "Stop" },
	},
	opts = {
		cmake_executor = {
			name = "quickfix",
			opts = { show = "always", position = "bottom", size = 10 },
		},
		cmake_runner = {
			name = "terminal",
			opts = { split_direction = "horizontal", split_size = 11 },
		},
		cmake_build_directory = "build/${variant:buildType}",
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
	},
}
