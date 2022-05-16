# if running bash
if [ -n "${BASH_VERSION}" ]; then
    # include .bashrc if it exists
    # otherwise .bashrc only executed for non-login shells
    if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi


# set PATH so it include user's private bin if it exists
if [ -d "${HOME}/bin" ]; then
    PATH="${HOME}/bin:${PATH}"
fi

# creat user's private directory local
if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:${PATH}"
else
    mkdir -p "${HOME}/.local/bin"
    PATH="${HOME}/.local/bin:${PATH}"
fi

if [ ! -d "${HOME}/.local/lib" ]; then
    mkdir -p "${HOME}/.local/lib"
fi

if [ ! -d "${HOME}/.local/share" ]; then
    mkdir -p "${HOME}/.local/share"
fi

# source aliases files
source "${HOME}"/.bash_aliases
source "${HOME}"/.bash_scripts

