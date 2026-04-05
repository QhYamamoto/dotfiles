vim.api.nvim_create_user_command("InsertNumbers", function()
  local start = tonumber(vim.fn.input "Enter start value (default: 1): ") or 1
  local step = tonumber(vim.fn.input "Enter step value (default: 1): ") or 1
  local format = vim.fn.input "Enter format (default: %d): "
  format = format ~= "" and format or "%d"

  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_row = start_pos[2]
  local start_col = start_pos[3]
  local end_row = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  local number = start
  for i, line in ipairs(lines) do
    local left_part = line:sub(1, start_col - 1)
    local right_part = line:sub(start_col)
    lines[i] = left_part .. string.format(format, number) .. right_part
    number = number + step
  end

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, {
  range = true,
  desc = "Insert sequential numbers into the selected block",
})

vim.api.nvim_create_user_command("MakeNumbersOnSelectedLinesSequential", function()
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_row = start_pos[2]
  local end_row = end_pos[2]

  local first_line = vim.fn.getline(start_row)

  local start = tonumber(string.match(first_line, "%d+")) or 1
  local step = tonumber(vim.fn.input "Enter step value (default: 1): ") or 1

  local current_number = start
  for row = start_row, end_row do
    local line = vim.fn.getline(row)
    local updated_line = string.gsub(line, "%d+", tostring(current_number))
    vim.fn.setline(row, updated_line)
    current_number = current_number + step
  end
end, { range = true })
