#!/bin/bash
CPWD=$(cd $(dirname $0) && pwd)
if [[ -x "${CPWD}"/vimrc-cfg/init.sh ]]; then 
  "${CPWD}"/vimrc-cfg/init.sh
else
  chmod +x "${CPWD}"/vimrc-cfg/init.sh
  "${CPWD}"/vimrc-cfg/init.sh
  chmod -x "${CPWD}"/vimrc-cfg/init.sh
fi

if [[ -x "${CPWD}"/zsh-bash-cfg/init.sh ]]; then
  "${CPWD}"/zsh-bash-cfg/init.sh
else
  chmod +x "${CPWD}"/zsh-bash-cfg/init.sh
  "${CPWD}"/zsh-bash-cfg/init.sh
  chmod -x "${CPWD}"/zsh-bash-cfg/init.sh
fi
