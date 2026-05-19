#!/usr/bin/env bash
#-*-coding utf-8 -*-
#########################################################################
# File Name: init.sh
# Author: 
# mail:
# Created Time: Fri 17 Dec 2021 02:38:57 PM CST
#########################################################################
CPWD=$(cd $(dirname $0) && pwd)
if [[ ! -d "${HOME}"/.tmux ]]; then
  mkdir -p "${HOME}"/.tmux/plugins
  mkdir -p "${HOME}"/.tmux/scripts
fi

if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
  echo "plugins/tpm is exists, skip"
elif [[ -x $(which git) ]]; then
  git clone https://github.com/tmux-plugin/tpm ~/.tmux/plugins/tpm
else
  echo "need git to install plugins"
  echo "git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm" > ~/.tmux/plugins/tpm_install.txt
fi

ln -fs "${CPWD}"/tmux.conf "${HOME}"/.tmux.conf
cp -fr "${CPWD}/scripts" "${HOME}/.tmux/"
# copy .service file to user's local directory
#if [[ ! -d "${HOME}"/.config/systemd/user ]]; then
#    mkdir -p "${HOME}"/.config/systemd/user
#fi
#cp "${CPWD}"/tmux-session.service "${HOME}"/.config/systemd/user/
#systemctl --user enable tmux-session.service --now
