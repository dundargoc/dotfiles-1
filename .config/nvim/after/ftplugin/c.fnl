(local {: set-path : tags} (require "ft/c"))

(setlocal commentstring "//%s")
(setlocal define&)
(setlocal include "^\\s*#\\s*include\\s*[\"<]\\@=")
(setlocal includeexpr&)
(setlocal textwidth 80)

; Support /// as a comment leader, used for writing Doxygen comments
(setlocal-= comments "://")
(setlocal+= comments [":///" "://"])

(set-path)
(tags)

(set vim.b.undo_ftplugin
  (.. vim.b.undo_ftplugin "|setl cms< def< inc< inex< path< tw< com<"))

(when (. (vim.api.nvim_get_commands {:builtin false}) :Man)
  (setlocal keywordprg ":Man")
  (set vim.b.undo_ftplugin
    (.. vim.b.undo_ftplugin "|setl kp<")))

(when (> (vim.fn.executable "clang-format") 0)
  (setlocal formatprg "clang-format -style=file -fallback-style=none")
  (set vim.b.undo_ftplugin
    (.. vim.b.undo_ftplugin "|setl fp<")))

(autocmd :ftplugin_c :BufWritePost "<buffer>" (tags true))

(set vim.b.undo_ftplugin (.. vim.b.undo_ftplugin "|au! ftplugin_c"))
