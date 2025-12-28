# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Autosuggestion strategy - completion only for better performance
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Update behavior
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 14

# Plugins - minimal set for performance
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# ============================================================================
# COMPLETION CONFIGURATION
# ============================================================================
# Skip slow security checks
ZSH_DISABLE_COMPFIX=true

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Cache completions for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ============================================================================
# KEY BINDINGS
# ============================================================================
# Tab accepts autosuggestion
bindkey '^I' autosuggest-accept

# Shift+Tab for normal completion menu (fallback)
bindkey '^[[Z' expand-or-complete

# Alternative shortcuts
bindkey '^[[1;5C' forward-word        # Ctrl+Right Arrow
bindkey '^[[1;5D' backward-word       # Ctrl+Left Arrow

# ============================================================================
# PERFORMANCE OPTIMIZATIONS
# ============================================================================
# Skip checking for terminal capabilities every time
skip_global_compinit=1

# Lazy load nvm (if you use it)
# export NVM_LAZY_LOAD=true

# ============================================================================
# MINIMAL FUNCTIONS
# ============================================================================
# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# Add local bin to PATH if it exists
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# ============================================================================
# POWERLEVEL10K
# ============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# ADDITIONAL OPTIMIZATIONS
# ============================================================================
# Disable auto-update prompts that slow down startup
DISABLE_AUTO_UPDATE=true

# Skip loading of some oh-my-zsh features for speed
DISABLE_UNTRACKED_FILES_DIRTY=true

# Lazy load completion system (uncomment if needed)
# autoload -Uz compinit
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#   compinit
# else
#   compinit -C
# fi

# ============================================================================
# SUPER USEFUL ALIASES
# ============================================================================

# Quick directory jumping (go back multiple levels)
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Quick edit config files (using VS Code as default)
alias zshrc='subl ~/.zshrc'
alias reload='source ~/.zshrc'
alias hosts='sudo subl --wait /etc/hosts'

# Editor shortcuts - VS Code
alias e='code .'        # 'e' for editor
alias edit='code'

# Sublime Text shortcuts (if installed)
alias s='subl .'
alias subl='subl'

# Git aliases that save tons of time
alias gaa='git add .'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'
alias gst='git stash'
alias gstp='git stash pop'
alias glog='git log --oneline --decorate --graph --all'
alias gwip='git add . && git commit -m "WIP"'
alias gnope='git reset --hard && git clean -df'

# Docker made easy
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dlog='docker-compose logs -f'
alias dstop='docker stop $(docker ps -aq)'
alias dclean='docker system prune -af'

# Network utilities
alias ports='netstat -tulanp | grep LISTEN'
alias myip='curl -s ifconfig.me'
alias localip='ip addr show | grep "inet " | grep -v 127.0.0.1'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

# System monitoring
alias cpu='top -o %CPU'
alias mem='top -o %MEM'
alias df='df -h'
alias du='du -h -d 1'

# Quick web server in current directory
alias serve='python3 -m http.server 8000'

# Copy current path to clipboard
alias pwdc='pwd | xclip -selection clipboard'

# ============================================================================
# AMAZING FUNCTIONS
# ============================================================================

# Quick note taking - appends to a daily note file
note() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$HOME/notes/$(date '+%Y-%m-%d').txt"
  echo "Note saved!"
}

# Search notes
searchnotes() {
  grep -r "$1" "$HOME/notes/" 2>/dev/null
}

# Create and enter directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Backup a file with timestamp
backup() {
  cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
  echo "Backed up to $1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Extract any archive type
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find and replace in files
findreplace() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: findreplace 'old_text' 'new_text'"
    return 1
  fi
  grep -rl "$1" . | xargs sed -i "s/$1/$2/g"
  echo "Replaced '$1' with '$2' in all files"
}

# Kill process by name
killp() {
  ps aux | grep -v grep | grep "$1" | awk '{print $2}' | xargs kill -9
  echo "Killed processes matching: $1"
}

# Find largest files/directories
largest() {
  du -ah . | sort -rh | head -n ${1:-10}
}

# Quick git commit with timestamp
qc() {
  git add .
  git commit -m "${1:-Quick commit $(date '+%Y-%m-%d %H:%M:%S')}"
}

# Weather in terminal
weather() {
  curl "wttr.in/${1:-Bengaluru}?format=3"
}

# Full weather report
weatherfull() {
  curl "wttr.in/${1:-Bengaluru}"
}

# Create a QR code from text
qr() {
  curl "qrenco.de/$1"
}

# Dictionary lookup
define() {
  curl -s "dict://dict.org/d:$1" | less
}

# Cheat sheets for commands
cheat() {
  curl "cheat.sh/$1"
}

# Find process using a port
whatport() {
  lsof -i ":$1"
}

# Create a temporary directory and cd into it
tmpd() {
  cd "$(mktemp -d)"
  pwd
}

# Compress folder to tar.gz
compress() {
  tar -czf "${1%/}.tar.gz" "$1"
  echo "Created ${1%/}.tar.gz"
}

# Generate random password
genpass() {
  openssl rand -base64 ${1:-16}
}

# Show directory tree (install tree first: sudo apt install tree)
tree() {
  command tree -C -L ${1:-2}
}

# Fuzzy find and cd (requires fzf: sudo apt install fzf)
fcd() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
}

# Fuzzy find and open in editor (requires fzf) - defaults to VS Code
fopen() {
  local file
  file=$(find ${1:-.} -type f 2>/dev/null | fzf +m) && code "$file"
}

# Open files by pattern
openf() {
  code $(find . -name "*$1*")
}

# Search and open file containing text
openg() {
  local file
  file=$(grep -rl "$1" . | fzf +m) && code "$file"
}

# Sublime-specific versions (if you install Sublime later)
sublf() {
  subl $(find . -name "*$1*" 2>/dev/null)
}

sublg() {
  local file
  file=$(grep -rl "$1" . 2>/dev/null | fzf +m) && subl "$file"
}

# Quick reminder (cron-like syntax)
remind() {
  sleep "$1" && notify-send "Reminder" "$2" &
  echo "Reminder set for $1: $2"
}

# Convert video to gif
vid2gif() {
  ffmpeg -i "$1" -vf "fps=10,scale=720:-1:flags=lanczos" -c:v gif "$2"
}

# Batch rename files
batchrename() {
  # Usage: batchrename "*.txt" "prefix_"
  for file in $1; do
    mv "$file" "$2$file"
  done
}

# Show disk usage with visualization
usage() {
  df -h | grep -v loop | awk '{print $5 " " $6}' | column -t
}

# JSON formatter (pipe JSON to this)
json() {
  python3 -m json.tool
}

# URL encode
urlencode() {
  python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

# URL decode
urldecode() {
  python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# Get public IP info
ipinfo() {
  curl -s "ipinfo.io/${1:-}" | python3 -m json.tool
}

# Test website response time
pingweb() {
  curl -o /dev/null -s -w "Time: %{time_total}s\nHTTP Code: %{http_code}\n" "$1"
}

# Download entire website
dlsite() {
  wget --recursive --no-clobber --page-requisites --html-extension \
    --convert-links --domains "$1" --no-parent "$1"
}

# Show command history stats
histats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head -20
}

# Safe delete (move to trash instead)
trash() {
  mkdir -p ~/.trash
  mv "$@" ~/.trash/
  echo "Moved to ~/.trash/"
}

# Restore from trash
untrash() {
  mv ~/.trash/"$1" .
  echo "Restored $1"
}

# Empty trash
emptytrash() {
  rm -rf ~/.trash/*
  echo "Trash emptied!"
}

# Start a timer
timer() {
  echo "Timer started for $1 seconds..."
  sleep "$1" && echo "⏰ Time's up!" && notify-send "Timer" "Time's up!"
}

# ============================================================================
# PRODUCTIVITY BOOSTERS
# ============================================================================

# Quick project navigation
alias work='cd ~/work'
alias projects='cd ~/projects'
alias downloads='cd ~/Downloads'
alias docs='cd ~/Documents'

# Create project structure
newproject() {
  mkdir -p "$1"/{src,tests,docs,scripts}
  cd "$1"
  git init
  touch README.md .gitignore
  echo "# $1" > README.md
  echo "Created project structure for $1"
}

# Show colorized cat output (requires pygments: pip install pygments)
ccat() {
  pygmentize -g "$1"
}

# Count lines of code in current directory
loc() {
  find . -name "*.$1" | xargs wc -l | tail -1
}

# ============================================================================
# FUN STUFF
# ============================================================================

# ASCII art welcome message
alias welcome='curl -s "http://artii.herokuapp.com/make?text=Welcome+Back"'

# Random joke
alias joke='curl -s https://icanhazdadjoke.com'

# Random fact
alias fact='curl -s https://uselessfacts.jsph.pl/random.json?language=en | python3 -m json.tool'

# Matrix effect (install cmatrix: sudo apt install cmatrix)
alias matrix='cmatrix -C cyan'

# Show system info with style (install neofetch: sudo apt install neofetch)
alias sysinfo='neofetch'

# ============================================================================
# SAFETY NETS
# ============================================================================

# Prevent accidental overwrites
alias cp='cp -i'
alias mv='mv -i'

# Safer rm with confirmation
alias rm='rm -I --preserve-root'

# Prevent chmod/chown on root
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
