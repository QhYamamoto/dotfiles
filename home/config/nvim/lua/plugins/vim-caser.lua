return {
  "arthurxavierx/vim-caser",
  event = "VeryLazy",
  init = function()
    -- disable default mappings
    vim.g.caser_no_mappings = 1

    -- mappings for normal mode
    vim.keymap.set("n", "<LEADER>cp", "<Plug>CaserMixedCase", { desc = "Convert to PascalCase" })
    vim.keymap.set("n", "<LEADER>cc", "<Plug>CaserCamelCase", { desc = "Convert to camelCase" })
    vim.keymap.set("n", "<LEADER>c_", "<Plug>CaserSnakeCase", { desc = "Convert to snake_case" })
    vim.keymap.set("n", "<LEADER>cU", "<Plug>CaserUpperCase", { desc = "Convert to UPPER_CASE" })
    vim.keymap.set("n", "<LEADER>ct", "<Plug>CaserTitleCase", { desc = "Convert to Title Case" })
    vim.keymap.set("n", "<LEADER>cs", "<Plug>CaserSpaceCase", { desc = "Convert to space Case" })
    vim.keymap.set("n", "<LEADER>c-", "<Plug>CaserKebabCase", { desc = "Convert to kebab-case" })
    vim.keymap.set("n", "<LEADER>c.", "<Plug>CaserDotCase", { desc = "Convert to dot.case" })

    -- mappings for visual mode
    vim.keymap.set("v", "<LEADER>cp", "<Plug>CaserVMixedCase", { desc = "Convert to PascalCase" })
    vim.keymap.set("v", "<LEADER>cc", "<Plug>CaserVCamelCase", { desc = "Convert to camelCase" })
    vim.keymap.set("v", "<LEADER>c_", "<Plug>CaserVSnakeCase", { desc = "Convert to snake_case" })
    vim.keymap.set("v", "<LEADER>cU", "<Plug>CaserVUpperCase", { desc = "Convert to UPPER_CASE" })
    vim.keymap.set("v", "<LEADER>ct", "<Plug>CaserVTitleCase", { desc = "Convert to Title Case" })
    vim.keymap.set("v", "<LEADER>cs", "<Plug>CaserVSpaceCase", { desc = "Convert to space Case" })
    vim.keymap.set("v", "<LEADER>c-", "<Plug>CaserVKebabCase", { desc = "Convert to kebab-case" })
    vim.keymap.set("v", "<LEADER>c.", "<Plug>CaserVDotCase", { desc = "Convert to dot.case" })
  end,
}
