# Migrated from zsh-bash-cfg/custom.bash_scripts
# Toggle HTTP/HTTPS proxy environment variables.
# - On WSL (1 or 2): uses the WSL host's default gateway IP (assumes a proxy on the host)
# - Otherwise: uses 127.0.0.1
#
# WSL detection: tests for the existence of the binfmt_misc interop handler file.
# This works on both WSL1 and WSL2, including custom kernels, and never
# matches native Linux. Recommended by canonical/snapd#12135 as the most
# robust WSL detection method.

function set_proxy
    if test -e /proc/sys/fs/binfmt_misc/WSLInterop
        # Extract default gateway IP from `ip route`
        set proxyIp (ip route show default | awk '/default/ {print $3; exit}')
        set -gx HTTP_PROXY "http://$proxyIp:10808"
    else
        set -gx HTTP_PROXY "http://127.0.0.1:10809"
    end
    set -gx HTTPS_PROXY $HTTP_PROXY
end
