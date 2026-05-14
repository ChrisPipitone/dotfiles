-- On Linux, load colorscheme directly from omarchy current theme's neovim.lua if present.
-- This handles custom themes (brutalism, city-783, etc.) without needing an explicit map entry.
if vim.fn.has("linux") == 1 then
  local theme_lua = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
  if vim.fn.filereadable(theme_lua) == 1 then
    local ok, specs = pcall(dofile, theme_lua)
    if ok and type(specs) == "table" then
      -- Omarchy themes use LazyVim/LazyVim to set the colorscheme; extract it instead of dropping it.
      local filtered = {}
      local colorscheme_name = nil
      for _, spec in ipairs(specs) do
        local name = type(spec[1]) == "string" and spec[1] or ""
        if name == "LazyVim/LazyVim" then
          if type(spec.opts) == "table" and spec.opts.colorscheme then
            colorscheme_name = spec.opts.colorscheme
          end
        else
          -- Ensure the plugin loads eagerly so it's ready before our theme-loader (priority 900).
          local s = vim.tbl_extend("force", {}, spec)
          s.lazy = false
          s.priority = s.priority or 1000
          table.insert(filtered, s)
        end
      end
      if colorscheme_name then
        local cs = colorscheme_name
        table.insert(filtered, {
          name = "omarchy-theme-loader",
          dir = vim.fn.stdpath("config"),
          lazy = false,
          priority = 900,
          config = function()
            local cs_ok, err = pcall(vim.cmd.colorscheme, cs)
            if not cs_ok then
              vim.notify("omarchy-theme-loader: failed to apply '" .. cs .. "': " .. err, vim.log.levels.WARN)
              pcall(vim.cmd.colorscheme, "habamax")
            end
          end,
        })
      end
      return filtered
    end
  end
end

-- Maps omarchy theme names to { colorscheme name, lazy.nvim plugin name }
local omarchy_map = {
  ["catppuccin"]       = { cs = "catppuccin",          plugin = "catppuccin" },
  ["catppuccin-latte"] = { cs = "catppuccin-latte",    plugin = "catppuccin" },
  ["ethereal"]         = { cs = "ethereal",             plugin = "ethereal" },
  ["everforest"]       = { cs = "everforest",           plugin = "everforest" },
  ["flexoki-light"]    = { cs = "flexoki-light",        plugin = "flexoki" },
  ["gruvbox"]          = { cs = "gruvbox",              plugin = "gruvbox" },
  ["gruvu"]            = { cs = "gruvbox-material",    plugin = "gruvbox-material" },
  ["hackerman"]        = { cs = "hackerman",            plugin = "hackerman" },
  ["kanagawa"]         = { cs = "kanagawa",             plugin = "kanagawa" },
  ["matte-black"]      = { cs = "matteblack",           plugin = "matteblack" },
  ["nord"]             = { cs = "nordfox",              plugin = "nightfox" },
  ["osaka-jade"]       = { cs = "bamboo",               plugin = "bamboo" },
  ["ristretto"]        = { cs = "monokai-pro",          plugin = "monokai-pro" },
  ["rose-pine"]        = { cs = "rose-pine-dawn",       plugin = "rose-pine" },
  ["tokyo-night"]      = { cs = "tokyonight-night",     plugin = "tokyonight" },
}

return {
  -- All theme plugins registered but lazy — installed on :Lazy sync, loaded only when needed
  { "ribru17/bamboo.nvim",        name = "bamboo",      lazy = true, priority = 1000 },
  { "bjarneo/ethereal.nvim",      name = "ethereal",    lazy = true, priority = 1000 },
  { "kepano/flexoki-neovim",      name = "flexoki",     lazy = true, priority = 1000 },
  { "ellisonleao/gruvbox.nvim",   name = "gruvbox",          lazy = true, priority = 1000 },
  { "sainnhe/gruvbox-material",   name = "gruvbox-material", lazy = true, priority = 1000 },
  { "bjarneo/hackerman.nvim",     name = "hackerman",   lazy = true, priority = 1000 },
  { "rebelot/kanagawa.nvim",      name = "kanagawa",    lazy = true, priority = 1000 },
  { "tahayvr/matteblack.nvim",    name = "matteblack",  lazy = true, priority = 1000 },
  { "loctvl842/monokai-pro.nvim", name = "monokai-pro", lazy = true, priority = 1000 },
  { "EdenEast/nightfox.nvim",     name = "nightfox",    lazy = true, priority = 1000 },
  { "rose-pine/neovim",           name = "rose-pine",   lazy = true, priority = 1000 },
  { "folke/tokyonight.nvim",      name = "tokyonight",  lazy = true, priority = 1000 },
  { "sainnhe/everforest",         name = "everforest",  lazy = true, priority = 1000 },
  { "catppuccin/nvim",            name = "catppuccin",  lazy = true, priority = 1000 },

  -- Reads active omarchy theme on Linux, ~/.config/theme.name on Mac
  {
    name = "theme-loader",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 900,
    config = function()
      local cs = "matteblack"
      local plugin = "matteblack"

      local function resolve(path)
        local f = vim.fn.expand(path)
        if vim.fn.filereadable(f) == 1 then
          local raw = vim.fn.readfile(f)[1]
          return raw and vim.trim(raw) or nil
        end
      end

      local theme_name
      if vim.fn.has("linux") == 1 then
        theme_name = resolve("~/.config/omarchy/current/theme.name")
      end
      theme_name = theme_name or resolve("~/.config/theme.name")

      if theme_name then
        local entry = omarchy_map[theme_name]
        if entry then
          cs = entry.cs
          plugin = entry.plugin
        end
      end

      require("lazy").load({ plugins = { plugin } })
      local ok, err = pcall(vim.cmd.colorscheme, cs)
      if not ok then
        vim.notify("theme-loader: failed to apply '" .. cs .. "': " .. err, vim.log.levels.WARN)
        pcall(vim.cmd.colorscheme, "habamax")
      end
    end,
  },
}
