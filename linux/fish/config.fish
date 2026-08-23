# Config do fish — equivalente ao setup bash do Omarchy.
# OMARCHY_PATH e PATH já vêm herdados da sessão (uwsm), não precisa setar aqui.

if status is-interactive
    # Sem mensagem de boas-vindas
    set fish_greeting ""

    # Prompt starship (mesmo visual do bash no Omarchy)
    starship init fish | source

    # cd inteligente via zoxide (cd aprende diretórios frequentes)
    zoxide init --cmd cd fish | source

    # mise (gerenciador de versões de linguagens)
    mise activate fish | source

    # ls turbinado com eza (mesmos aliases do bash do Omarchy)
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'

    # Atalhos de diretório
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'

    # Git
    alias g='git'

    # bat/cat
    alias cat='bat'

    # Abrir arquivo/URL no app padrão
    function open
        xdg-open $argv >/dev/null 2>&1 &
    end
end
