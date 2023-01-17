#!/bin/bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)
VER_INFO=$(vim --version | head -1)
if [[ ${VER_INFO} =~ [[:alpha:][:blank:]\-]+([[:digit:]])\.[[:digit:]].+ ]]; then
    if (( ${BASH_REMATCH[-1]} < 9 )); then
        ln -fs "${SCRIPT_PWD}"/vimrc "${HOME}"/.vimrc
    else
        ln -fs "${SCRIPT_PWD}/vimrc-9" "${HOME}/.vimrc"
    fi
else
    echo "no vim installed, use legacy vimrc"
    ln -fs "${SCRIPT_PWD}/vimrc" "${HOME}/.vimrc"
fi
