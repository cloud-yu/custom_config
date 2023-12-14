#!/usr/bin/env bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)

# create symbol link instead copy file
ln -sf "${SCRIPT_PWD}"/custom.bash_aliases "${HOME}"/.bash_aliases
ln -sf "${SCRIPT_PWD}"/custom.bash_scripts "${HOME}"/.bash_scripts

if [[ -n "${BASH_VERSION}" ]]; then
    ln -sf "${SCRIPT_PWD}"/custom.profile "${HOME}"/.profile
fi

if [[ -x $(which zsh) ]]; then
    if [[ -e "${SCRIPT_PWD}"/zinit_custom.zshrc ]]; then
        ln -sf "${SCRIPT_PWD}"/custom.profile "${HOME}"/.zprofile
        cp "${SCRIPT_PWD}"/zinit_custom.zshrc "${HOME}"/.zshrc
    else
        ln -sf "${SCRIPT_PWD}"/custom.profile "${HOME}"/.zprofile
        cp "${SCRIPT_PWD}"/antigen_custom.zshrc "${HOME}"/.zshrc

    fi
fi
