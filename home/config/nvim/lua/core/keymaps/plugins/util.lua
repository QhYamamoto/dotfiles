local M = {}

function M.set_maps(maps)
  for _, map in ipairs(maps) do
    local opts = vim.deepcopy(map.opts or {})
    if map.desc ~= nil then
      opts.desc = map.desc
    end
    vim.keymap.set(map.mode, map.lhs, map.rhs, opts)
  end
end

return M
