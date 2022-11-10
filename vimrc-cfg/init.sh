#!/bin/bash
SCRIPT_PWD=$(cd "$(dirname "$0")" && pwd)
ln -fs "${SCRIPT_PWD}"/vimrc "${HOME}"/.vimrc
