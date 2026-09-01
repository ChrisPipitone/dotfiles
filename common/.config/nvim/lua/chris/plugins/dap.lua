return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				automatic_installation = true,
			})
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",

		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"weissle/persistent-breakpoints.nvim",
		},

		keys = {
			{
				"<leader>db",
				function()
					require("persistent-breakpoints.api").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("persistent-breakpoints.api").set_conditional_breakpoint()
				end,
				desc = "Conditional breakpoint",
			},
			{
				"<leader>dx",
				function()
					require("persistent-breakpoints.api").clear_all_breakpoints()
				end,
				desc = "Clear all breakpoints",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue / start",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle UI",
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("nvim-dap-virtual-text").setup({ commented = true })
			require("persistent-breakpoints").setup({
				load_breakpoints_event = { "BufReadPost" },
			})

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			local codelldb_config = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Launch (with args)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local args = vim.fn.input("Args: ")
						return vim.split(args, " ", { trimempty = true })
					end,
				},
				{
					name = "Attach to PID",
					type = "codelldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}

			dap.configurations.c = codelldb_config
			dap.configurations.cpp = codelldb_config
			dap.configurations.rust = codelldb_config
		end,
	},
}
