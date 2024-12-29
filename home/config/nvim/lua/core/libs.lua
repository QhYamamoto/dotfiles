---Execute callback for each table item
---@param table table<any>
---@param callback fun(value: any, index: integer)
_G.iforeach = function(table, callback)
  for index, value in ipairs(table) do
    callback(value, index)
  end
end

---@param table table<any>
---@param callback fun(value: any, key: string)
_G.foreach = function(table, callback)
  for key, value in pairs(table) do
    callback(value, key)
  end
end

--- Escape special characters in a string for use in pattern matching
---@param str string
---@return string
_G.escape_pattern = function(str)
  local escaped_str, _ = str:gsub("([%[%]%(%)%*%+%-%?%^%$])", "%%%1")
  return escaped_str
end
