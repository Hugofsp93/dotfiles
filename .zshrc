export ZSH="/Users/hugofelipe/.oh-my-zsh"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config 'zash')"
  # json
  # robbyrussell
  # tokyonight_storm
  # zash
fi

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
git
zsh-completions
zsh-autosuggestions
docker
docker-compose
bundler
)

source $ZSH/oh-my-zsh.sh
source /Users/hugofelipe/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
. "$HOME/.local/bin/env"

export PATH="/Applications/Antigravity.app/Contents/Resources/app/bin:$PATH"
export EDITOR='nano'

# always use bat even if type cat
alias cat='bat'
# always use GNU nano from Homebrew
alias nano='/opt/homebrew/bin/nano'

# Docker aliases
alias up='docker compose up --remove-orphans -d && docker attach web'
alias docup='docker compose up --remove-orphans'
alias down='docker compose down --remove-orphans'
alias bundle='docker compose run web bundle install'
alias build='docker compose build'
alias test='docker compose run web bundle exec rails test'

# Modern ls replacement (eza)
alias ls='eza -gF --icons --tree --level=1 --group-directories-first --hyperlink'
alias ls2='eza --icons --tree --level=2 --group-directories-first'

# Utilities
alias tap="taproom"
alias code="antigravity"
alias spotify="spotify_player"

# Project Aliases
alias sigfdne='cd /Users/hugofelipe/Desktop/Development/Sudene/sigfdne'
alias sibf='cd /Users/hugofelipe/Desktop/Development/Sudene/sibf'
alias ponto='cd /Users/hugofelipe/Desktop/Development/Sudene/ponto'
alias helpdesk='cd /Users/hugofelipe/Desktop/Development/Sudene/helpdesk'
alias helpdesk_sudene='cd /Users/hugofelipe/Desktop/Development/Sudene/helpdesk_sudene'
alias wizard='cd /Users/hugofelipe/Desktop/Development/Rust/alchemy'
alias vedmin='cd /Users/hugofelipe/Desktop/Development/Rust/vedmin'
alias denaut='cd /Users/hugofelipe/Desktop/Development/DenAut'

export PATH="$PATH:/Users/hugofelipe/Downloads/claude-hfi"
eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
bindkey '^[[1;9A' atuin-up-search

# bun completions
[ -s "/Users/hugofelipe/.bun/_bun" ] && source "/Users/hugofelipe/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
