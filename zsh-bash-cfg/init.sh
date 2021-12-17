#!/bin/bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)

echo "${SCRIPT_PWD}"

# copy profile to $HOME


if [[ -n "${BASH_VERSION}" ]]; then
    cp "${SCRIPT_PWD}"/custom.profile "${HOME}"/.profile
fi

if [[ -x $(which zsh) ]]; then
    if [[ -e "${SCRIPT_PWD}"/zinit_custom.zshrc ]]; then
        cp "${SCRIPT_PWD}"/custom.profile "${HOME}"/.zprofile
        cp "${SCRIPT_PWD}"/zinit_custom.zshrc "${HOME}"/.zshrc
    else
        cp "${SCRIPT_PWD}"/custom.profile "${HOME}"/.zprofile
        cp "${SCRIPT_PWD}"/antigen_custom.zshrc "${HOME}"/.zshrc

    fi
fi
