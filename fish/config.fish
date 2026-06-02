if status is-interactive
    # Commands to run in interactive sessions can go here
    
    ## check whether fisher is installed, if not install it
    if not functions -q fisher
        echo "Installing Fisher..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    end

    ## define plugin list here
    set -U FISH_PLUGINS "jorgebucaran/fisher" "ilancosman/tide"

    ## check and install missing plugins
    for plugin in $FISH_PLUGINS
        if not contains $plugin (fisher list)
            echo "Installing missing plugin: $plugin"
            fisher install $plugin
        end
    end
    
    ## init zoxide
    if type -q zoxide
        zoxide init fish | source
    end
end
