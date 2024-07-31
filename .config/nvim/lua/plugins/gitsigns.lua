return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Navigation
			map("n", "]h", gs.next_hunk, "Next Hunk")
			map("n", "[h", gs.prev_hunk, "Prev Hunk")

			-- Actions
			map("n", "<LEADER>hs", gs.stage_hunk, "Stage hunk")
			map("n", "<LEADER>hr", gs.reset_hunk, "Reset hunk")
			map("v", "<LEADER>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage hunk")
			map("v", "<LEADER>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset hunk")

			map("n", "<LEADER>hS", gs.stage_buffer, "Stage buffer")
			map("n", "<LEADER>hR", gs.reset_buffer, "Reset buffer")

			map("n", "<LEADER>hu", gs.undo_stage_hunk, "Undo stage hunk")

			map("n", "<LEADER>hp", gs.preview_hunk, "Preview hunk")

			map("n", "<LEADER>hb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
			map("n", "<LEADER>hB", gs.toggle_current_line_blame, "Toggle line blame")

			map("n", "<LEADER>hd", gs.diffthis, "Diff this")
			map("n", "<LEADER>hD", function()
				gs.diffthis("~")
			end, "Diff this ~")

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
		end,
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 500,
		},
	},
}
