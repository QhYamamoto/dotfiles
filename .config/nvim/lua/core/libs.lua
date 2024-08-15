---Execute callback for each table item
---@param table table<any>
---@param callback fun(v: any, i: integer)
_G.foreach = function(table, callback)
  for i, v in ipairs(table) do
    callback(v, i)
  end
end
