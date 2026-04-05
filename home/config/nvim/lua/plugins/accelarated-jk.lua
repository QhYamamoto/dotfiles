return {
  "rhysd/accelerated-jk",
  config = function()
    require("core.keymaps.plugins").accelerated_jk.setup()

    -- Customize the acceleration speed.
    -- Increasing the interval between table elements will increase the speed.
    vim.g.accelerated_jk_acceleration_table = { 2, 7, 12, 17, 22, 27 }
  end,
}
