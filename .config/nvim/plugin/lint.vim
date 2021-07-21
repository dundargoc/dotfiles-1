function! s:load()
lua <<
local ok, lint = pcall(require, "lint")
if not ok then
    return
end

lint.linters_by_ft = {
    ["sh"] = { "shellcheck" },
    ["vim"] = { "vint" },
    ["lua"] = { "luacheck" },
    ["nix"] = { "nix" },
}

vim.cmd("autocmd! lint BufWritePost * lua require('lint').try_lint()")
.
endfunction

augroup lint
    autocmd!
    autocmd BufWritePre * ++once call s:load()
augroup END