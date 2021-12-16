# options
setopt completealiases
setopt nocaseglob
setopt sharehistory histignoredups appendhistory

# set history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# set dir stack
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups cdablevars

# disable correction
unsetopt correctall
unsetopt correct

# init zinit
ZINIT="${HOME}"/.zinit/bin/zinit.zsh

## install zinit if not exist
if [ ! -f "${ZINIT}" ]; then
	if [ -x $(which git) ]; then
		mkdir "${HOME}"/.zinit && git clone https://github.com/zdharma-continuum/zinit.git "${HOME}"/.zinit/bin
	else
		echo "ERROR: please install git before installation!!"
		exit
	fi
fi

# load zinit
source "${ZINIT}"

zinit load zdharma-continuum/history-search-multi-word

zinit ice depth"1"
zinit light romkatv/powerlevel10k

zinit wait lucid light-mode for \
	atinit"zicompinit; zicdreplay" \
		zdharma-continuum/fast-syntax-highlighting \
	atinit \
		rupa/z \
	as"completion" \
		OMZP::docker/_docker 

zinit wait lucid for \
	PZTM::completion

zinit wait lucid light-mode for \
	atload"_zsh_autosuggest_start" \
		zsh-users/zsh-autosuggestions \
	blockf atpull'zinit creinstall -q .' \
		zsh-users/zsh-completions


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
