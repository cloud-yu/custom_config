# git aliases
alias gst='git status'

# optional: use `eza` replace `ls`, if eza is installed
if [[ -x $(which eza) ]]; then
    alias ls='eza'
else
# ls aliases to enable color
    alias ls='ls --color=auto'
    alias lf='ls -F'
fi


# grep alias to enable color
alias grep='grep --color=auto'
# ip route alias
alias ip6='ip -6'
