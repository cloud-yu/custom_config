# options
setopt completealiases
setopt nocaseglob
setopt sharehistory histignoredups appendhistory

# set history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# change WORDCHARS 
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# set dir stack
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups cdablevars

# disable correction
unsetopt correctall
unsetopt correct

# bindkeys
bindkey -e # Use emacs mode keyshortcut
bindkey '\e[3~' delete-char  # Del
bindkey '\e[2~' overwrite-mode  # Ins
bindkey '\eOH' beginning-of-line  # Home in editor
bindkey '\eOF' end-of-line  # End in editor

# init zinit
ZINIT="${HOME}"/.zinit/bin/zinit.zsh

## install zinit if not exist
if [ ! -f "${ZINIT}" ]; then
	if [ -x $(which git) ]; then
		mkdir -p "${HOME}"/.zinit && git clone https://github.com/zdharma-continuum/zinit.git "${HOME}"/.zinit/bin
	else
		echo "ERROR: please install git before installation!!"
		exit
	fi
fi

# load zinit
source "${ZINIT}"

zinit ice depth"1"
zinit light romkatv/powerlevel10k

local GH_RAW_URL='https://raw.githubusercontent.com'

zinit wait lucid light-mode for \
        PZTM::completion \
	atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' atload"
	zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}" pick"c.zsh" nocompile:! \
		trapd00r/LS_COLORS \
		rupa/z \
    atload blockf atpull'!zinit cuninstall $(pwd)' atpull'zinit creinstall -q $(pwd)' \
        zsh-users/zsh-completions \
	as"completion" nocompile id-as"docker-completion/_docker" is-snippet "${GH_RAW_URL}/docker/cli/master/contrib/completion/zsh/_docker" \
		OMZP::docker-compose/_docker-compose \
	as"completion" nocompile id-as"git-completion/_git" is-snippet "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
		zdharma-continuum/history-search-multi-word \
	atload"fast-theme -q clean" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"ZSH_AUTOSUGGEST_STRATEGY=(history completion); 
        _zsh_autosuggest_start; zicompinit; zicdreplay" \
        zsh-users/zsh-autosuggestions

if [ -z "${TMUX}" ];then
    function tabby_precmd() { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }
    add-zsh-hook -Uz precmd tabby_precmd
fi

if [ -n "${TMUX}" ];then
    function refresh_tmux_env() { eval "$(tmux show-environment -s)" }
    add-zsh-hook -Uz preexec refresh_tmux_env
fi
