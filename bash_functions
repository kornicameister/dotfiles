#!/bin/bash

docker_gc() {
    docker run --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /etc:/etc:ro spotify/docker-gc
}

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

# git related

# Public: Removes all .orig files after rebase/merge/cherry-pick ops
#
# No args
#
# Examples
#   git_clean_orig
#
# Returns
#   null
git_clean_orig() {
    find $(pwd) -type f -name '*.orig' -print0 | xargs -0 rm -fv || true
}

# Public: Clones git repo and sets it up
#
# Clones git repository into "directory"
# and:
#   * sets remote name based on address
#   * for gerrit executes `git-review -r gerrit -s master`
#
# Args:
#   $1 url - repository url
#   $2 directory - where repository should be cleaned
#
# Examples
#   git_clone ssh://trebskit@review.openstack.org:29418/openstack/pymod2pkg pymod2pkg
# Returns
#   HEAD commit title
git_clone() {
    local repo=$1
    local directory=$2

    local remote_name
    local pwd=$(pwd)

    if [[ $repo =~ .*review\.openstack\.org.* ]]; then
        remote_name="gerrit"
    elif [[ $repo =~ .*github.* ]]; then
        remote_name="github"
    elif [[ $repo =~ .*gitlab.* ]]; then
        remote_name="gitlab"
    fi

    git clone $repo $directory --progress --origin $remote_name --branch master

    if [ "$remote_name" = "gerrit" ]; then
        cd $directory
        git-review -r gerrit -s master
        cd $pwd
    fi

    cd $directory
    git show --oneline | head -1
    cd $pwd
}

replace_in_all() {
    local expr_what=$1
    local expr_to=$2
    local where=${3:-'*'}
    sed -e "s/${expr_what}/${expr_to}/g" -i $(find -type f -name "${where}" -exec grep -inHl --binary-files=without-match "${expr_what}" {} /dev/null \;)
}
