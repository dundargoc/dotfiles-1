(local servers {
  :rust_analyzer {}
  :clangd {}
  :gopls {:analyses {:unusedparams true :unusedwrite true :nilness true}}
  :pyright {}
})

(fn show-virtual-text [ns bufnr line]
  (let [id 1]
    (when (= (. (vim.api.nvim_get_mode) :mode) :n)
      (let [items (vim.lsp.diagnostic.get_line_diagnostics bufnr line)]
        (if (empty-or-nil? items)
            (vim.api.nvim_buf_del_extmark bufnr ns id)
            (let [chunks (vim.lsp.diagnostic.get_virtual_text_chunks_for_line bufnr line items)]
              (vim.api.nvim_buf_set_extmark bufnr ns line 0 {: id :virt_text chunks})))))))

(autocmd :my-lspconfig :FileType "go,c,cpp,rust,python" :once
  (exec "packadd nvim-lspconfig")
  (when vim.g.lspconfig
    (local ns (vim.api.nvim_create_namespace :diagnostics))
    (fn on-attach [client bufnr]
      (vim.api.nvim_buf_set_option bufnr :omnifunc "v:lua.vim.lsp.omnifunc")

      (keymap :n "<C-]>" "<Cmd>lua vim.lsp.buf.definition()<CR>" {:buffer bufnr :silent true})
      (keymap :n "K" "<Cmd>lua vim.lsp.buf.hover()<CR>" {:buffer bufnr :silent true})
      (keymap :n "gr" "<Cmd>lua vim.lsp.buf.references()<CR>" {:buffer bufnr :silent true})
      (keymap :n "gR" "<Cmd>lua vim.lsp.buf.rename()<CR>" {:buffer bufnr :silent true})

      (-> vim.lsp.diagnostic.on_publish_diagnostics
          (vim.lsp.with {:virtual_text false :underline false})
          (->> (tset vim.lsp.handlers "textDocument/publishDiagnostics")))

      (augroup :my-lspconfig
        (autocmd :CursorMoved (: "<buffer=%d>" :format bufnr) []
          (let [pos (vim.api.nvim_win_get_cursor 0)
                line (- (. pos 1) 1)]
            (show-virtual-text ns bufnr line)))

        (autocmd :User :LspDiagnosticsChanged []
          (vim.lsp.diagnostic.set_loclist {:open false})
          (let [pos (vim.api.nvim_win_get_cursor 0)
                line (- (. pos 1) 1)]
            (show-virtual-text ns bufnr line))))

      (exec "doautocmd User LspAttached"))

    (each [name settings (pairs servers)]
      (let [config (. (require :lspconfig) name)]
        (config.setup {
          : on_attach
          :settings {name settings}
          :flags {:debounce_text_changes 150}
        })

        (when (vim.tbl_contains config.filetypes vim.bo.filetype)
          (config.autostart))))))
