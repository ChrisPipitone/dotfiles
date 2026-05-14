return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "echasnovski/mini.icons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>ee", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
    { "<leader>ef", "<cmd>Neotree reveal<CR>", desc = "Reveal current file" },
    { "<leader>eg", "<cmd>Neotree git_status<CR>", desc = "Git status" },
    { "<leader>ec", "<cmd>Neotree close<CR>", desc = "Close explorer" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = { ".git", "node_modules" },
      },
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
    },
    window = {
      width = 35,
      mappings = {
        ["<space>"] = "none",
      },
    },
    default_component_configs = {
      indent = {
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        expander_collapsed = "",
        expander_expanded = "",
      },
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
  },
}
