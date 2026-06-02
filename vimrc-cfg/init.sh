#!/usr/bin/env bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)
VER_INFO=$(vim --version | head -1)

XDG_CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"

if [[ -d "${XDG_CONFIG}" ]]; then
    VIMRC_DIR="${XDG_CONFIG}/vim"
    mkdir -p "${VIMRC_DIR}"
    VIMRC_TARGET="${VIMRC_DIR}/vimrc"
else
    VIMRC_TARGET="${HOME}/.vimrc"
fi

if [[ ${VER_INFO} =~ [[:alpha:][:blank:]\-]+([[:digit:]])\.[[:digit:]].+ ]]; then
    if (( ${BASH_REMATCH[-1]} < 9 )); then
        ln -fs "${SCRIPT_PWD}/vimrc" "${VIMRC_TARGET}"
    else
        ln -fs "${SCRIPT_PWD}/vimrc-9" "${VIMRC_TARGET}"
    fi
else
    echo "no vim installed, use legacy vimrc"
    ln -fs "${SCRIPT_PWD}/vimrc" "${VIMRC_TARGET}"
fi
