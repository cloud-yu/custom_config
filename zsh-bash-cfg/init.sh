#!/usr/bin/env bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)

XDG_CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"

if [[ -d "${XDG_CONFIG}" ]]; then
    BASH_CFG_DIR="${XDG_CONFIG}/bash"
else
    BASH_CFG_DIR="${HOME}/.bash_cfg"
fi

# create symbol link instead copy file
mkdir -p "${BASH_CFG_DIR}"
ln -sf "${SCRIPT_PWD}"/custom.bash_aliases "${BASH_CFG_DIR}"/bash_aliases.cfg
ln -sf "${SCRIPT_PWD}"/custom.bash_scripts "${BASH_CFG_DIR}"/bash_scripts.cfg

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
