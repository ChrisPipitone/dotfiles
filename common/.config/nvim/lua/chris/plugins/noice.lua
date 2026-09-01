return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
    },
    views = {
      cmdline_popup = {
        position = { row = "10%", col = "50%" },
        size = { min_width = 60, width = "auto", height = "auto" },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NoiceCmdlinePopup",
            FloatBorder = "NoiceCmdlinePopupBorder",
            FloatTitle = "NoiceCmdlinePopupTitle",
          },
        },
      },
      cmdline_popupmenu = {
        relative = "editor",
        position = { row = "16%", col = "50%" },
        size = { width = 60, height = "auto", max_height = 15 },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
        },
      },
      mini = {
        border = { style = "rounded" },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
  end,
}
