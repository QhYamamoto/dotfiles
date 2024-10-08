return {
  "rhysd/accelerated-jk",
  config = function()
    local keymap = vim.keymap

    local rhs_for_j = function()
      return "<Plug>(accelerated_jk_" .. (vim.v.count == 0 and "gj" or "j") .. ")"
    end
    keymap.set("n", "j", rhs_for_j, { noremap = false, silent = true, expr = true })
    keymap.set("n", "<Down>", rhs_for_j, { noremap = false, silent = true, expr = true })

    local rhs_for_k = function()
      return "<Plug>(accelerated_jk_" .. (vim.v.count == 0 and "gk" or "k") .. ")"
    end
    keymap.set("n", "k", rhs_for_k, { noremap = false, silent = true, expr = true })
    keymap.set("n", "<Up>", rhs_for_k, { noremap = false, silent = true, expr = true })

    -- Customize the acceleration speed.
    -- Increasing the interval between table elements will increase the speed.
    vim.g.accelerated_jk_acceleration_table = { 2, 7, 12, 17, 22, 27 }
  end,
}
