#!/bin/bash
SCRIPT_PWD=$(cd $(dirname $0); pwd)

echo ${SCRIPT_PWD}

# copy profile to $HOME
if [ -n "${BASH_VERSION}" ]; then
    cp ${SCRIPT_PWD}/custom.profile ${HOME}/.profile
else
    cp ${SCRIPT_PWD}/custom.profile ${HOME}/.zprofile
    cp ${SCRIPT_PWD}/*.zshrc ${HOME}/.zshrc
fi

