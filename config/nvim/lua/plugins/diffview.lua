return {
  "sindrets/diffview.nvim",
  config = function()
    local keymap = vim.keymap
    local last_diffview_args = nil

    keymap.set("n", "<LEADER>gdo", function()
      local input = vim.fn.input "DiffviewOpen args: "
      if input == "" then
        input = "HEAD~1..HEAD"
      end

      last_diffview_args = input

      vim.cmd("DiffviewOpen " .. input)
    end, { desc = "Open diff view with custom args" })

    keymap.set("n", "<LEADER>gdc", "<CMD>:DiffviewClose<CR>", { desc = "Close diff view" })

    vim.keymap.set("n", "<LEADER>gdr", function()
      if not last_diffview_args then
        print "No previous Diffview state to restore!"
        return
      end

      vim.cmd("DiffviewOpen " .. last_diffview_args)
    end, { desc = "Restore last closed diff view" })

    local function get_git_rev_from_clipboard()
      local rev = vim.fn.getreg "+" -- get string from clipboard
      if rev:match "^[0-9a-fA-F]+$" then
        return rev
      else
        return nil
      end
    end

    function DiffViewOpenWithGitRev()
      local rev = get_git_rev_from_clipboard()
      if rev then
        local cmd = ":DiffviewOpen " .. rev .. "~1.." .. rev
        print(rev)
        vim.cmd(cmd)
      else
        print "Invalid HashID on clipboard."
      end
    end

    keymap.set(
      "n",
      "<LEADER>gdr",
      "<CMD>lua DiffViewOpenWithGitRev()<CR>",
      { desc = "Open diff view ({HashId on clipboard}~1..{HashID on clipboard})", noremap = true, silent = true }
    )
  end,
}
