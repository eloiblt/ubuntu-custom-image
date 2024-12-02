if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Eviter les doublons dans l'historique
export HISTCONTROL=ignoredups
export HISTSIZE=10000  # Nombre de commandes à garder en mémoire
export SAVEHIST=10000  # Nombre de commandes à sauvegarder dans le fichier d'historique
export HISTFILE=~/.zsh_history  # Fichier d'historique

alias ll="ls -lAhiS --group-directories-first --color=auto"
alias privateip="ipcalc $(hostname -I | awk '{print $1}')"
alias publicip="ipcalc $(curl --no-progress-meter ifconfig.me)"
alias updateall="sudo apt -y update && sudo apt -y upgrade && sudo apt full-upgrade -y && sudo apt -y dist-upgrade && sudo apt -y autoremove && sudo apt -y clean && sudo apt -y autoclean"
alias gitclean="git branch | grep -v '^*' | xargs git branch -D"

source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source ~/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f /root/.p10k.zsh ]] || source /root/.p10k.zsh