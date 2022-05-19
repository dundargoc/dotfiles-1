(fn obsession []
  (match (pcall vim.fn.ObsessionStatus :$ :S)
    (true "") ""
    (true s) (.. " " s)
    _ ""))

(fn lsp-progress-messages [client]
  (let [messages []]
    (each [k v (pairs client.messages.progress)]
      (let [msg (if v.message
                    (: "%s: %s" :format v.title v.message)
                    v.title)]
        (table.insert messages (if v.percentage
                                   (: "%s (%%%%%d)" :format msg v.percentage)
                                   msg)))
      (when v.done
        (tset client.messages.progress k nil)))
    messages))

(fn lsp []
  (match (vim.lsp.get_active_clients {:bufnr 0})
    [client] (let [messages (lsp-progress-messages client)]
               (match (length messages)
                 0 ""
                 n (: " %s " :format (table.concat messages ", "))))
    _ ""))


(fn diagnostics []
  (let [diags (vim.diagnostic.get 0 {:severity {:min vim.diagnostic.severity.WARN}})
        num-errors (accumulate [sum 0 _ v (ipairs diags)]
                     (if (= v.severity vim.diagnostic.severity.ERROR)
                         (+ sum 1)
                         sum))
        num-warnings (- (length diags) num-errors)]
    (match (values num-errors num-warnings)
      (0 0) ""
      (e 0) (: "E: %d " :format e)
      (0 w) (: "W: %d " :format w)
      (e w) (: "E: %d W: %d " :format e w))))

(fn filename [buf curwin]
  (let [name (match (buf:get_name)
               "" "Untitled"
               n (n:gsub "%%" "%%%%"))
        fname (vim.fn.fnamemodify name ":~:.")
              parent (fname:match "^(.*/)")
              tail (vim.fn.fnamemodify name ":t")
              (parent-hl tail-hl) (if vim.bo.modified
                                      (values "%1*" "%1*")
                                      (not curwin)
                                      (values "" "")
                                      (values "%2*" "%3*"))]
    (: "%s %%<%s%s%s %%*" :format parent-hl (or parent "")
                                  tail-hl tail)))

(fn tabline []
  (let [tabpagenr (vim.fn.tabpagenr)
        items []]
    (for [i 1 (vim.fn.tabpagenr :$)]
      (let [hi (if (= i tabpagenr) :TabLineSel :TabLine)
            cwd (-> (vim.fn.getcwd -1 i)
                    (vim.fn.fnamemodify ":~")
                    (vim.fn.pathshorten))]
        (table.insert items (: "%%#%s#%%%dT %d %s " :format hi i i cwd))))
    (table.insert items "%#TabLineFill#%T")
    (table.concat items)))

(fn statusline []
  (let [buf nvim.current.buf
        win nvim.current.win
        curwin (= (tonumber vim.g.actual_curwin) win.id)
        items [(obsession)
               (filename buf curwin)
               (if vim.bo.readonly
                   "%r "
                   "")
               (if vim.wo.previewwindow
                   "%w "
                   "")
               "%="
               (lsp)
               (diagnostics)
               (if (and vim.bo.modifiable (not vim.bo.readonly))
                   (let [t []]
                     (match vim.bo.fileformat
                       "unix" nil
                       ff (table.insert t (if (= ff :dos) "CRLF" "CR")))
                     (match vim.bo.fileencoding
                       "utf-8" nil
                       "" nil
                       fenc (table.insert t fenc))
                     (if (< 0 (length t))
                         (: "%%4* %s " :format (table.concat t " "))
                         ""))
                   "")
               (if curwin "%8*" "")
               (match vim.bo.filetype
                 "" ""
                 ft (match (vim.lsp.get_active_clients {:bufnr buf.id})
                      [client] (: " %s/%s " :format ft client.name)
                      _ (: " %s " :format ft)))
               (if curwin "%9*" "")
               " %l:%c %P "]]
    (table.concat items)))

(fn winbar []
  (let [buf nvim.current.buf
        curwin (= (tonumber vim.g.actual_curwin) nvim.current.win.id)
        items [" "
               (filename buf curwin)
               (if vim.bo.readonly
                   "%r "
                   "")
               " "]]
    (table.concat items)))

{: statusline
 : winbar
 : tabline}
