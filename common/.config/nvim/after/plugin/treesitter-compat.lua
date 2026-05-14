-- Guards set-lang-from-info-string! against nil TSNode objects that occur when
-- render-markdown calls parser:parse() with partial buffer ranges in nvim 0.12.
--
-- Applied in three places because nvim-treesitter re-registers its own handler
-- when it lazy-loads, which overwrites this patch:
--   1. Immediately at after/plugin/ startup
--   2. After nvim-treesitter finishes loading (the critical one for .md files)
--   3. After VeryLazy as a final safety net

local function patch()
  vim.treesitter.query.add_directive(
    "set-lang-from-info-string!",
    function(match, _, bufnr, pred, metadata)
      local capture_id = pred[2]
      local node = match[capture_id]
      if not node then return end
      if type(node) == "table" then node = node[1] end
      if not node or type(node.range) ~= "function" then return end
      local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
      if not ok or not text then return end
      local lang = text:lower()
      local filetype = vim.filetype.match({ filename = "a." .. lang })
      metadata["injection.language"] = filetype or lang
    end,
    { force = true, all = true }
  )
end

patch()

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(ev)
    if ev.data == "nvim-treesitter" then
      patch()
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = patch,
})
