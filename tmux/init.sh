#!/usr/bin/env bash
#-*-coding utf-8 -*-
#########################################################################
# File Name: init.sh
# Author: 
# mail:
# Created Time: Fri 17 Dec 2021 02:38:57 PM CST
#########################################################################
CPWD=$(cd $(dirname $0) && pwd)

XDG_CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"

if [[ -d "${XDG_CONFIG}" ]]; then
    TMUX_DIR="${XDG_CONFIG}/tmux"
    TMUX_PLUGIN_DIR="${TMUX_DIR}/plugins"
    TMUX_SCRIPTS_DIR="${TMUX_DIR}/scripts"
    TMUX_CONF_TARGET="${TMUX_DIR}/tmux.conf"
else
    TMUX_DIR="${HOME}/.tmux"
    TMUX_PLUGIN_DIR="${TMUX_DIR}/plugins"
    TMUX_SCRIPTS_DIR="${TMUX_DIR}/scripts"
    TMUX_CONF_TARGET="${HOME}/.tmux.conf"
fi

mkdir -p "${TMUX_PLUGIN_DIR}"
mkdir -p "${TMUX_SCRIPTS_DIR}"

if [[ -d "${TMUX_PLUGIN_DIR}/tpm" ]]; then
    echo "plugins/tpm is exists, skip"
elif [[ -x $(which git) ]]; then
    git clone https://github.com/tmux-plugin/tpm "${TMUX_PLUGIN_DIR}/tpm"
else
    echo "need git to install plugins"
    echo "git clone https://github.com/tmux-plugins/tpm.git \"${TMUX_PLUGIN_DIR}/tpm\"" > "${TMUX_PLUGIN_DIR}/tpm_install.txt"
fi

ln -fs "${CPWD}/tmux.conf" "${TMUX_CONF_TARGET}"
cp -fr "${CPWD}/scripts/." "${TMUX_SCRIPTS_DIR}/"
