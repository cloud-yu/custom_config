# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# init zinit
ZINIT="${HOME}"/.zinit/bin/zinit.zsh

## install zinit if not exist
if [ ! -f "${ZINIT}" ]; then
    # if git has been installed, clone zinit repo
    if $(type git >/dev/null); then
		mkdir -p "${HOME}"/.zinit && git clone https://github.com/zdharma-continuum/zinit.git "${HOME}"/.zinit/bin
	else
		echo "ERROR: please install git before installation!!"
		return 404
	fi
fi

# load zinit
source "${ZINIT}"

zinit ice depth"1"
zinit light romkatv/powerlevel10k
zinit snippet PZTM::completion

local GH_RAW_URL='https://raw.githubusercontent.com'

# zsh-users/zsh-syntax-highlighting should load before zsh-users/zsh-history-substring-search, accroding to the latter's github document
zinit wait lucid light-mode for \
	atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' atload"
	zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}" pick"c.zsh" nocompile:! \
		trapd00r/LS_COLORS \
		rupa/z \
    atload blockf atpull'!zinit cuninstall $(pwd)' atpull'zinit creinstall -q $(pwd)' \
        zsh-users/zsh-completions \
	as"completion" nocompile id-as"docker-completion/_docker" is-snippet "${GH_RAW_URL}/docker/cli/master/contrib/completion/zsh/_docker" \
		OMZP::docker-compose/_docker-compose \
    atload"ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets pattern cursor line regexp)"  \
        zsh-users/zsh-syntax-highlighting  \
        zdharma-continuum/history-search-multi-word \
    atload"ZSH_AUTOSUGGEST_STRATEGY=(history completion); ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8,underline'; _zsh_autosuggest_start; zicompinit; zicdreplay" \
        zsh-users/zsh-autosuggestions

# set history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# change WORDCHARS 
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# set dir stack
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups cdablevars

# options
setopt completealiases
setopt nocaseglob nonomatch
setopt sharehistory histignoredups appendhistory
# unset pathdirs (this is set by PZTM)
unsetopt pathdirs

# disable correction
unsetopt correctall
unsetopt correct


# bindkeys
bindkey -e # Use emacs mode keyshortcut
bindkey '\e[3~' delete-char  # Del
bindkey '\e[2~' overwrite-mode  # Ins
bindkey '\eOH' beginning-of-line  # Home in editor
bindkey '\eOF' end-of-line  # End in editor

# some other functions
if [ -z "${TMUX}" ];then
    function tabby_precmd() { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }
    add-zsh-hook -Uz precmd tabby_precmd
fi

if [ -n "${TMUX}" ];then
    function refresh_tmux_env() { eval "$(tmux show-environment -s)" }
    add-zsh-hook -Uz preexec refresh_tmux_env
fi

# if installed direnv, add direnv hook to the shell
if $(type direnv >/dev/null); then
    eval "$(direnv hook zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
