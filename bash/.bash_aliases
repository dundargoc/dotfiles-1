alias l="ls -lh"
alias ll="ls -Alh"

alias g="git"

if hash nvim 2>/dev/null; then
    alias vi="nvim"
    alias vim="nvim"
fi

if [ ! -z "$EDITOR" ]; then
    alias e="$EDITOR"
fi

if [ ! -z "$BROWSER" ]; then
    alias b="$BROWSER"
fi

alias open="xdg-open"
alias d="dirs -v"

mkdcd() {
    mkdir -p "$1" && cd "$1"
}

__cd() {
    builtin cd "$@"
    if [ $? -eq 0 ]; then
        pushd -n "$(pwd)" >/dev/null
    fi
}
alias cd=__cd

for i in $(seq 1 9)
do
    alias "$i"="builtin cd ~$i"
done

alias tmux="tmux -2"
