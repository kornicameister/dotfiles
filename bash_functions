# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --height 95% --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --header "Press CTRL-S to toggle sort" \
      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                 xargs -I % sh -c 'git show --color=always % | head -200 '" \
      --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'vim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
}

git_clean_orig() {
    find $(pwd) -type f -name '*.orig' -print0 | xargs -0 rm -fv || true
}

replace_in_all() {
    local expr_what=$1
    local expr_to=$2
    local where=${3:-'*'}
    sed -e "s/${expr_what}/${expr_to}/g" -i $(find -type f -name "${where}" -exec grep -inHl "${expr_what}" {} /dev/null \;)
}

