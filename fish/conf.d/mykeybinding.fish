bind -e ctrl-space
bind -e shift-space
bind shift-space 'test -n "$(commandline)" && commandline -i " " (commandline --search-field >/dev/null && echo --search-field)'
