return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-project.nvim",
    "ThePrimeagen/harpoon",
  },
  config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    local auto_session = require "auto-session"

    local project_actions_ok, project_actions = pcall(require, "telescope._extensions.project.actions")

    local function change_project_directory(project_path)
      vim.api.nvim_set_current_dir(project_path)
    end

    local function open_projects()
      local loaded, load_err = pcall(telescope.load_extension, "project")
      if not loaded then
        vim.notify(("telescope-project.nvim failed to load: %s"):format(load_err), vim.log.levels.WARN)
        return
      end

      telescope.extensions.project.project {}
    end

    telescope.setup {
      extensions = {
        project = {
          base_dirs = { "~" },
          cd_scope = { "global", "tab", "window" },
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true,
          on_project_selected = function(prompt_bufnr)
            if not project_actions_ok then
              vim.notify("telescope-project actions are unavailable", vim.log.levels.WARN)
              return
            end

            local project_path = project_actions.get_selected_path(prompt_bufnr)
            actions.close(prompt_bufnr)

            local restored = auto_session.autosave_and_restore(project_path)
            if not restored then
              change_project_directory(project_path)
            end

            vim.defer_fn(function()
              pcall(function()
                require("harpoon.ui").nav_file(1)
              end)
            end, 50)
          end,
        },
      },
      defaults = {
        path_display = { "smart" },
        file_ignore_patterns = { ".git/" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--ignore", "--iglob", "!.git", "--hidden", "--files" },
        },
        grep_string = {
          additional_args = { "--hidden" },
        },
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
    }

    telescope.load_extension "fzf"

    local keymap = vim.keymap

    keymap.set("n", "<LEADER>ff", "<CMD>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<LEADER>fr", "<CMD>Telescope resume<CR>", { desc = "Fuzzy find with cache" })
    keymap.set("n", "<LEADER>fp", open_projects, { desc = "Find project" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string in cwd" })
    keymap.set("n", "<LEADER>ft", "<CMD>TodoTelescope<CR>", { desc = "Find todos" })
  end,
}
