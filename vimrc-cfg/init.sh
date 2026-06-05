#!/usr/bin/env bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)
VER_INFO=$(vim --version | head -1)

XDG_CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"

vim_major=0
if [[ ${VER_INFO} =~ [[:alpha:][:blank:]\-]+([[:digit:]])\.[[:digit:]].+ ]]; then
    vim_major=${BASH_REMATCH[-1]}
else
    echo "no vim installed, use legacy vimrc"
fi

if (( vim_major >= 9 )); then
    src="${SCRIPT_PWD}/vimrc-9"
    if [[ -d "${XDG_CONFIG}" ]]; then
        mkdir -p "${XDG_CONFIG}/vim"
        target="${XDG_CONFIG}/vim/vimrc"
    else
        target="${HOME}/.vimrc"
    fi
else
    src="${SCRIPT_PWD}/vimrc"
    target="${HOME}/.vimrc"
fi

ln -fs "${src}" "${target}"
