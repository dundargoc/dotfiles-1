(local {: node-at-cursor : context : context-text : lang-has-parser} (require :treesitter))

(local state {})

(fn close []
  (match state.winid
    w (do
        (nvim.win.close w true)
        (set state.winid nil))))

(fn show-context [bufnr]
  (match (context bufnr)
    contexts (let [lang (. vim.bo bufnr :filetype)
                   win nvim.current.win
                   [{: textoff : topline}] (vim.fn.getwininfo win.id)
                   width (- (win:get_width) textoff)]
               (var text [])
               (each [_ ctx (ipairs contexts)]
                 (let [start-row (ctx:start)]
                   (if (< start-row (+ (- topline 1) (length text)))
                       (table.insert text (context-text bufnr ctx)))))
               (if (< 0 (length text))
                   (let [b (match (?. state bufnr :bufnr)
                             (where n (vim.api.nvim_buf_is_valid n)) n
                             _ (let [b (vim.api.nvim_create_buf false true)]
                                 (tset vim.bo b :readonly true)
                                 (tset vim.bo b :filetype (. vim.bo bufnr :filetype))
                                 (when (not (. state bufnr))
                                   (tset state bufnr {}))
                                 (tset state bufnr :bufnr b)
                                 b))
                         w (match state.winid
                             (where n (vim.api.nvim_win_is_valid n)) (do
                                                                       (vim.api.nvim_win_set_config n {:relative :win
                                                                                                       :row 0
                                                                                                       :col textoff
                                                                                                       :height (length text)
                                                                                                       : width})
                                                                       n)
                             _ (let [w (vim.api.nvim_open_win b false {:relative :win
                                                                       :win win.id
                                                                       :row 0
                                                                       :col textoff
                                                                       : width
                                                                       :height (length text)
                                                                       :focusable false
                                                                       :style :minimal
                                                                       :noautocmd true})]
                                 (tset vim.wo w :winhighlight "NormalFloat:TreesitterContext")
                                 (set state.winid w)
                                 w))]
                     (nvim.win.set_buf w b)
                     (nvim.buf.set_lines b 0 -1 true text))
                   (close)))
    _ (close)))

(autocmd treesitter# [:WinScrolled :WinEnter :CursorMoved :CursorMovedI] "*"
  #(match (vim.fn.getcmdwintype)
     "" (let [buf nvim.current.buf
              lang (. vim.bo buf.id :filetype)]
          (if (lang-has-parser lang)
              (show-context buf.id)
              (close)))))
