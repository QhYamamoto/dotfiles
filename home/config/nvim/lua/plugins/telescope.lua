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
    local plugin_keymaps = require("core.keymaps.plugins").telescope
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

    local function split_display_path(opts, path)
      local tail = require("telescope.utils").path_tail(path)
      local cwd = (opts and opts.cwd) or vim.loop.cwd()
      local rel = path
      if cwd and cwd ~= "" and path:sub(1, #cwd) == cwd then
        rel = path:sub(#cwd + 2)
      end
      local parent = rel:match "(.+)/[^/]+$"
      return tail, parent
    end

    local function render_path(head, parent, filename)
      local text = parent and (head .. "  " .. parent) or head
      local display, hl_group, icon = require("telescope.utils").transform_devicons(filename, text)
      local highlights = {}
      if hl_group then
        highlights[#highlights + 1] = { { 0, #icon }, hl_group }
      end
      if parent then
        local prefix = icon and (#icon + 1) or 0
        local dir_start = prefix + #head + 2
        highlights[#highlights + 1] = { { dir_start, #display }, "TelescopeResultsComment" }
      end
      return display, highlights
    end

    local file_base, grep_base
    local function rebuild_entry_bases()
      local make_entry = require "telescope.make_entry"
      file_base = make_entry.gen_from_file { cwd = vim.loop.cwd() }
      grep_base = make_entry.gen_from_vimgrep { cwd = vim.loop.cwd() }
    end
    rebuild_entry_bases()
    vim.api.nvim_create_autocmd("DirChanged", { callback = rebuild_entry_bases })

    local function file_entry_maker(line)
      local entry = file_base(line)
      if not entry then
        return nil
      end
      entry.display = function(e)
        local tail, parent = split_display_path({ cwd = vim.loop.cwd() }, e.value)
        return render_path(tail, parent, e.value)
      end
      return entry
    end

    local function grep_entry_maker(line)
      local entry = grep_base(line)
      if not entry then
        return nil
      end
      entry.display = function(e)
        local tail, parent = split_display_path({ cwd = vim.loop.cwd() }, e.filename)
        local head = e.lnum and string.format("%s:%s", tail, e.lnum) or tail
        return render_path(head, parent, e.filename)
      end
      return entry
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
        path_display = function(opts, path)
          local tail, parent = split_display_path(opts, path)
          if not parent or parent == "" then
            return tail
          end
          return string.format("%s  %s", tail, parent)
        end,
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.65,
          },
        },
        file_ignore_patterns = { ".git/" },
        mappings = plugin_keymaps.insert_mappings(actions),
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--ignore", "--iglob", "!.git", "--hidden", "--files" },
          entry_maker = file_entry_maker,
        },
        grep_string = {
          additional_args = { "--hidden" },
          entry_maker = grep_entry_maker,
        },
        live_grep = {
          additional_args = { "--hidden" },
          entry_maker = grep_entry_maker,
        },
      },
    }

    telescope.load_extension "fzf"

    plugin_keymaps.setup(open_projects)
  end,
}
