return {
  "ysmb-wtsg/in-and-out.nvim",
  config = function()
    vim.keymap.set("n", "<C-l>", function()
      require("in-and-out").in_and_out()
    end)
  end,
}
