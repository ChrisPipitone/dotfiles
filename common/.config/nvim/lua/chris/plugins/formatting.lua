return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Biome where it is supported, prettier everywhere else. Biome has no
    -- yaml/markdown/svelte/liquid support and its HTML support is still
    -- experimental, so those stay on prettier outright.
    local js = { "biome", "prettier", stop_after_first = true }

    conform.setup({
      -- conform's biome sets cwd but not require_cwd, so by default it runs
      -- even with no biome.json and silently reformats with nvim's shiftwidth.
      -- Requiring the config makes it skip, so stop_after_first reaches
      -- prettier in projects that don't use biome.
      formatters = {
        biome = { require_cwd = true },
      },
      formatters_by_ft = {
        javascript = js,
        typescript = js,
        javascriptreact = js,
        typescriptreact = js,
        json = js,
        jsonc = js,
        css = js,
        graphql = js,
        svelte = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
    end, { desc = "Format file or range" })
  end,
}
