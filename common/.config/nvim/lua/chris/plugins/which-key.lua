return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 500,
    spec = {
      { "<leader>e", group = "explorer" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "git hunks" },
      { "<leader>s", group = "splits" },
      { "<leader>t", group = "tabs" },
      { "<leader>w", group = "session" },
      { "<leader>x", group = "trouble/todo" },
      { "<leader>c", group = "clangd" },
      { "<leader>C", group = "cmake" },
      { "<leader>G", group = "godbolt" },
      { "<leader>d", group = "debug" },
    },
  },
}
