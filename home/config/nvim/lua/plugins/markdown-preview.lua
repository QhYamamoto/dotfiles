return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown", "plantuml" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown", "plantuml" }
  end,
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<LEADER>mp", "<CMD>MarkdownPreview<CR>", { desc = "MarkdownPreview" })
  end,
}
