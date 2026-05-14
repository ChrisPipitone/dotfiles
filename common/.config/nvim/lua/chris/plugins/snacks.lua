return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    lazygit = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    scroll = { enabled = false },
    words = { enabled = true },
  },
  keys = {
    { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
    { "<leader>gL", function() Snacks.lazygit.log() end, desc = "LazyGit log" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
  },
}
