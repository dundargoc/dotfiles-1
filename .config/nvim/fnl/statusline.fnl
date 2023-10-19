(fn obsession []
  (match (pcall vim.fn.ObsessionStatus :$ :S)
    (true "") ""
    (true s) (.. " " s)
    _ ""))

(fn lsp-progress [client]
  (var percentage nil)
  (let [messages (icollect [{: value} client.progress]
                   (when (?. value :kind)
                     (when value.percentage
                       (set percentage (math.max (or percentage 0) value.percentage)))
                     (if value.message
                         (: "%s: %s" :format value.title value.message)
                         value.title)))
        message (table.concat messages ", ")]
    (if percentage
        (: "%s (%%%%%d)" :format message percentage)
        message)))

(fn lsp []
  (case-try vim.b.lsp
    name (vim.lsp.get_clients {:bufnr 0 : name})
    [client] (lsp-progress client)
    message (: " %s " :format message)
    (catch
      _ "")))

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

(fn filename [buf fancy]
  (let [name (match (nvim.buf_get_name buf)
               "" "Untitled"
               n (n:gsub "%%" "%%%%"))
        fname (vim.fn.fnamemodify name ":~:.")
              parent (fname:match "^(.*/)")
              tail (vim.fn.fnamemodify name ":t")
              (parent-hl tail-hl) (if vim.bo.modified
                                      (values "%1*" "%1*")
                                      fancy
                                      (values "%2*" "%3*")
                                      (values "" ""))]
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
  (let [buf (nvim.get_current_buf)
        win (nvim.get_current_win)
        term (= :terminal (. vim.bo buf :buftype))
        curwin (= (tonumber vim.g.actual_curwin) win)
        fancy (and curwin (not term))
        items [(obsession)
               (filename buf fancy)
               (if vim.bo.readonly
                   "%r "
                   "")
               (if vim.wo.previewwindow
                   "%w "
                   "")
               "%="
               (lsp)
               (diagnostics)
               (if fancy "%4*" "")
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
                         (: " %s " :format (table.concat t " "))
                         ""))
                   "")
               (if fancy "%8*" "")
               (match vim.bo.filetype
                 "" ""
                 ft (match vim.b.lsp
                      name (: " %s/%s " :format ft name)
                      _ (: " %s " :format ft)))
               (if fancy "%9*" "")
               " %l:%c %P "]]
    (table.concat items)))

{: statusline
 : tabline}
