local M = {}

function M.on_attach(ev)
  local opts = { buffer = ev.buf, silent = true }

  opts.desc = "Show LSP references"
  vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)

  opts.desc = "Go to declaration"
  vim.keymap.set("n", "gd", vim.lsp.buf.declaration, opts)

  opts.desc = "Show LSP definitions"
  vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)

  opts.desc = "Show LSP implementations"
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

  opts.desc = "Show LSP type definitions"
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

  opts.desc = "See available code actions"
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

  opts.desc = "Smart rename"
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  opts.desc = "Show buffer diagnostics"
  vim.keymap.set("n", "<leader>D", "<CMD>Telescope diagnostics bufnr=0<CR>", opts)

  opts.desc = "Show line diagnostics"
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

  opts.desc = "Go to previous diagnostic"
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump { count = -1, float = true }
  end, opts)

  opts.desc = "Go to next diagnostic"
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump { count = 1, float = true }
  end, opts)

  opts.desc = "Show documentation for what is under cursor"
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  opts.desc = "Restart LSP"
  vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if client ~= nil and client.supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable()
  end
end

function M.typescript_on_attach(_, bufnr)
  local execute_workspace_command = function(params)
    local result = vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 5000)
    return result ~= nil
  end

  vim.keymap.set("n", "<LEADER>oi", function()
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = "typescript.organizeImports",
    }
    execute_workspace_command(params)
    vim.cmd "silent! write"
  end, { buffer = bufnr, noremap = true, silent = true })
end

return M
