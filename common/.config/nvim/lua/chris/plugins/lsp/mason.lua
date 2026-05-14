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
      ensure_installed = {
        "ts_ls",
        "html",
        "tailwindcss",
        "pyright",
        "ruff",
        "clangd",
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
