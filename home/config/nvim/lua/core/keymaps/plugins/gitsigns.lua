local M = {}

function M.on_attach(bufnr)
  local gs = package.loaded.gitsigns

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "]h", gs.next_hunk, "Next Hunk")
  map("n", "[h", gs.prev_hunk, "Prev Hunk")
  map("n", "<LEADER>hs", gs.stage_hunk, "Stage hunk")
  map("n", "<LEADER>hr", gs.reset_hunk, "Reset hunk")
  map("v", "<LEADER>hs", function()
    gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, "Stage hunk")
  map("v", "<LEADER>hr", function()
    gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, "Reset hunk")
  map("n", "<LEADER>hS", gs.stage_buffer, "Stage buffer")
  map("n", "<LEADER>hR", gs.reset_buffer, "Reset buffer")
  map("n", "<LEADER>hu", gs.undo_stage_hunk, "Undo stage hunk")
  map("n", "<LEADER>hp", gs.preview_hunk, "Preview hunk")
  map("n", "<LEADER>hb", function()
    gs.blame_line { full = true }
  end, "Blame line")
  map("n", "<LEADER>hB", gs.toggle_current_line_blame, "Toggle line blame")
  map("n", "<LEADER>hd", gs.diffthis, "Diff this")
  map("n", "<LEADER>hD", function()
    gs.diffthis "~"
  end, "Diff this ~")
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
end

return M
