# Migrated from zsh-bash-cfg/custom.profile
# Environment variables and PATH setup (login-time equivalent for fish)

# Prepend user's private bin to PATH if it exists
if test -d $HOME/bin
    fish_add_path $HOME/bin
end

# Ensure ~/.local/bin exists and prepend it to PATH
if not test -d $HOME/.local/bin
    mkdir -p $HOME/.local/bin
end
fish_add_path $HOME/.local/bin

# Ensure other ~/.local subdirectories exist
if not test -d $HOME/.local/lib
    mkdir -p $HOME/.local/lib
end
if not test -d $HOME/.local/share
    mkdir -p $HOME/.local/share
end

# Set default EDITOR (prefer vim, fall back silently if not installed)
if type -q vim
    set -gx EDITOR vim
end

# Set GPG_TTY for GPG signing/encryption prompts
if type -q tty
    set -gx GPG_TTY (tty)
end
