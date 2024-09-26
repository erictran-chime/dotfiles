require("config.lazy")
print("hello")

-- keymaps
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Remove blank lines between import statements
    local save_cursor = vim.fn.getpos(".")  -- Save the cursor position
    vim.cmd([[silent! g/^import (\_.\{-})$/s/\n\s*\n/\r/g]])  -- Remove blank lines within import block
    vim.fn.setpos('.', save_cursor)         -- Restore the cursor position

    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
