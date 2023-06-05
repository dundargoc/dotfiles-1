(fn grep [{: args}]
  (let [grepcmd (case (vim.o.grepprg:gsub "%$%*" args)
                  (s 0) (.. s " " args)
                  (s n) s)
        stdout (vim.uv.new_pipe false)
        chunks []]
    (nvim.exec_autocmds :QuickFixCmdPre {:pattern "grep" :modeline false})
    (var handle nil)
    (fn callback []
      (when handle
        (handle:close))
      (vim.schedule #(let [lines (-> chunks table.concat (vim.split "\n" {:trimempty true}))]
                       (vim.fn.setqflist [] " " {:title grepcmd
                                                 : lines
                                                 :efm vim.o.grepformat
                                                 :nr "$"})
                       (nvim.exec_autocmds :QuickFixCmdPost {:pattern "grep" :modeline false}))))
    (set handle (vim.uv.spawn vim.o.shell
                                {:args ["-c" grepcmd] :stdio [nil stdout nil]}
                                callback))
    (stdout:read_start
      (fn [err data]
        (assert (not err) err)
        (when data
          (table.insert chunks data))))
    (print grepcmd)))

(command :Grep {:nargs :+ :complete :file_in_path} grep)

(autocmd grep# :QuickFixCmdPost :grep {:nested true}
  #(let [list (vim.fn.getqflist)]
     (vim.cmd (.. "cclose|botright " (math.min 10 (length list)) "cwindow"))))

(vim.cmd "
cnoreabbrev <expr> gr    (getcmdtype() ==# ':' && getcmdline() ==# 'gr')    ? 'Grep'  : 'gr'
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
")

(keymap :n "<Space>/" ":Grep " {:silent false})
(keymap :x "<Space>/" "y:<C-U>Grep <C-R>\"" {:silent false})
(keymap :n "<Space>*" ":Grep <C-R><C-W><CR>")
(keymap :x "<Space>*" "y:<C-U>Grep <C-R>\"<CR>")
