return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "dockerfile", "html",
        "javascript", "json", "lua", "markdown", "markdown_inline",
        "python", "query", "regex", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- seamless pane navigation between nvim splits and tmux panes
  "christoomey/vim-tmux-navigator",

  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize split" },
    },
  },
}
