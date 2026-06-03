# Migrated from zsh-bash-cfg/custom.bash_scripts
# Unset HTTP/HTTPS proxy environment variables.

function del_proxy
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
end
