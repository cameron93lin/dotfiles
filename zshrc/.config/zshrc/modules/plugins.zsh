# Zinit Plugin Manager
declare -A ZINIT
ZINIT[HOME_DIR]=~/.config/zinit

# Installer
if [[ ! -f $HOME/.config/zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.config/zinit" && command chmod g-rwX "$HOME/.config/zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.config/zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
 
source "$HOME/.config/zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
 
# Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light-mode for \
    zdharma-continuum/zinit-annex-rust \
    IsraelSampaio/z-a-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

zinit wait="1" lucid light-mode for \
    kevinhwang91/zsh-tmux-capture \
    hlissner/zsh-autopair \
    hchbaw/zce.zsh \
    Aloxaf/gencomp \
    agkozak/zsh-z \
    wfxr/forgit

zinit wait="1" lucid for \
    OMZ::lib/clipboard.zsh \
    OMZ::lib/git.zsh \
    OMZ::plugins/systemd/systemd.plugin.zsh \
    OMZ::plugins/sudo/sudo.plugin.zsh \
    OMZ::plugins/git/git.plugin.zsh
 
zinit ice mv=":cht.sh -> cht.sh" atclone="chmod +x cht.sh" as="program"
zinit snippet https://cht.sh/:cht.sh
 
zinit ice mv=":zsh -> _cht" as="completion"
zinit snippet https://cheat.sh/:zsh
 
zinit ice svn 
zinit snippet OMZ::plugins/extract
 
zinit ice svn 
zinit snippet OMZ::plugins/pip
 
zinit as="completion" for \
    OMZ::plugins/docker/_docker \
    OMZ::plugins/rust \
    OMZ::plugins/fd/_fd
 
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
    Aloxaf/fzf-tab \
 blockf \
    zsh-users/zsh-completions \
 atclone="dircolors -b LS_COLORS > c.zsh" atpull='%atclone' pick='c.zsh' \
    trapd00r/LS_COLORS \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Completion Styling
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
