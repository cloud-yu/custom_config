#!/bin/bash
#-*-coding utf-8 -*-
#########################################################################
# File Name: init.sh
# Author: 
# mail:
# Created Time: Fri 17 Dec 2021 02:38:57 PM CST
#########################################################################
CPWD=$(cd $(dirname $0) && pwd)
if [[ ! -d "${HOME}"/.tmux/plugins ]]; then
  mkdir -p "${HOME}"/.tmux/plugins
fi

if [[ -x $(which git) ]]; then
  git clone https://github.com/tmux-plugin/tpm ~/.tmux/plugins/tpm
else
  echo "need git to install plugins"
  echo "git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm" > ~/.tmux/plugins/tpm_install.txt
fi

cp "${CPWD}"/tmux.conf "${HOME}"/.tmux.conf

# copy .service file to user's local directory
if [[ ! -d "${HOME}"/.config/systemd/user ]]; then
    mkdir -p "${HOME}"/.config/systemd/user
fi
cp "${CPWD}"/tmux-session.service "${HOME}"/.config/systemd/user/
systemctl --user enable tmux-session.service --now
