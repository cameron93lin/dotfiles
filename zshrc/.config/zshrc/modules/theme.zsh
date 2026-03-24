# Starship prompt
if [[ -x "$HOME/.config/bin/starship" ]]; then
    eval "$($HOME/.config/bin/starship init zsh)"
elif command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    # Fallback prompt
    PROMPT="%{$fg_bold[cyan]%}%n%{$reset_color%}@%{$fg_bold[cyan]%}%m %{$fg_bold[green]%}%1~ %{$reset_color%}%#"
fi
