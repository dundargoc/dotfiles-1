(autocmd ft/zig :LspAttach "<buffer>"
  #(match vim.g.zig_std_dir
     d (silent (vim.lsp.buf.add_workspace_folder d))))

(set vim.bo.formatprg "zig fmt --stdin")
(set vim.bo.textwidth 100)

(match vim.g.zig_tags_file
  tags (when (= 1 (vim.fn.filereadable tags))
         (set vim.bo.tags (.. vim.o.tags "," tags))))