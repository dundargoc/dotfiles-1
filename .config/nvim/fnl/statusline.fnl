(fn git []
  (match vim.b.gitsigns_head
    v v
    nil (match (pcall vim.fn.FugitiveHead)
          (true "") ""
          (true branch) (.. branch " ")
          _ "")))

(fn obsession []
  (match (pcall vim.fn.ObsessionStatus)
    (true "") ""
    (true s) (.. s " ")
    _ ""))

(fn lsp []
  (let [clients (icollect [client-id client (pairs (vim.lsp.buf_get_clients))]
                  (: "%s/%d" :format client.config.name client-id))]
    (match (length clients)
      0 ""
      _ (: "(%s) " :format (table.concat clients ", ")))))

(fn diagnostics []
  (let [diags (vim.diagnostic.get 0 {:severity {:min vim.diagnostic.severity.WARN}})
        num-errors (accumulate [sum 0 _ v (ipairs diags)]
                     (if (= v.severity vim.diagnostic.severity.ERROR)
                         (+ sum 1)
                         sum))
        num-warnings (- (length diags) num-errors)]
    (match (values num-errors num-warnings)
      (0 0) ""
      (e 0) (: "E:%d" :format e)
      (0 w) (: "W:%d" :format w)
      (e w) (: "E:%d, W:%d" :format e w))))

{: git
 : lsp
 : obsession
 : diagnostics}
