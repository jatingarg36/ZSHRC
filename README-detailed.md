# Enhanced .zshrc Configuration

A comprehensive, performance-optimized Zsh configuration file that transforms your terminal into a powerful development environment. This configuration includes a beautiful theme, intelligent autosuggestions, syntax highlighting, and hundreds of useful aliases and functions to boost your productivity.

## 🚀 Quick Setup

To automatically set up the Zsh configuration, run the setup script:

```bash
# Clone this repository
git clone https://github.com/jatingarg36/ZSHRC.git ~/zshrc-config
cd ~/zshrc-config

# Run the setup script
bash setup.sh
```

The setup script will automatically install all required dependencies, configure your `.zshrc` file, and set up tmux configuration (if tmux is installed). On macOS, it also installs `cowsay` and `lolcat` via Homebrew.

## 🌟 Features

- **Powerlevel10k Theme**: Beautiful, fast, and highly customizable terminal theme
- **Oh My Zsh Integration**: Leverages the power of Oh My Zsh framework
- **Intelligent Autosuggestions**: Auto-complete commands as you type
- **Syntax Highlighting**: Color-coded command syntax for better readability
- **Performance Optimized**: Configured for fast shell startup and operation
- **Extensive Aliases**: Shortcuts for Git, Docker, system monitoring, and more
- **Utility Functions**: Helper functions for common development tasks
- **Safety Features**: Protected commands to prevent accidental data loss

## 📋 Prerequisites

Before installing this `.zshrc` configuration, ensure you have the following installed:

### Required

1. **Zsh** (version 5.0.8 or later)
   ```bash
   # macOS (usually pre-installed)
   zsh --version

   # Linux (Ubuntu/Debian)
   sudo apt install zsh

   # Verify installation
   zsh --version
   ```

2. **Oh My Zsh**
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Powerlevel10k Theme**
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```

4. **Zsh Autosuggestions Plugin**
   ```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   ```

5. **Zsh Syntax Highlighting Plugin**
   ```bash
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

### Optional (for additional features)

- **tmux** - Terminal multiplexer (configuration file `~/.tmux.conf` will be installed automatically if tmux is present)
- **fzf** (fuzzy finder) - for `fcd`, `fopen`, `openg` functions
- **VS Code** or **Sublime Text** - for editor shortcuts
- **tree** - for directory tree visualization
- **pygments** (Python) - for colorized cat output
- **cmatrix** - for Matrix effect
- **neofetch** - for system info display
- **ffmpeg** - for video to GIF conversion
- **cowsay**, **lolcat** (macOS only) - Installed automatically via Homebrew by the setup script

> 🔧 **For tmux configuration and usage guide**, see [README-tmux.md](README-tmux.md) for a complete reference on terminal multiplexing, sessions, windows, panes, and power-user workflows.


## 🚀 Installation

### Step 1: Backup Your Existing .zshrc

```bash
# Backup current .zshrc if it exists
if [ -f ~/.zshrc ]; then
  cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
  echo "Backup created at ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi
```

### Step 2: Copy the zshrc File

```bash
# Clone this repository
git clone https://github.com/jatingarg36/ZSHRC.git ~/zshrc-config

# Cd into the repository directory
cd zshrc-config 

# now you're in the repository directory
cp zshrc ~/.zshrc
```

### Step 3: Configure Powerlevel10k

After installation, when you open a new terminal, Powerlevel10k configuration wizard will appear. Follow the prompts to customize your prompt, or run:

```bash
p10k configure
```

This will create `~/.p10k.zsh` configuration file. The configuration wizard will ask you about:
- Prompt style (Lean, Classic, Rainbow, etc.)
- Prompt elements (git status, time, etc.)
- Character encoding
- Prompt separators
- And more customization options

### Step 4: Create Necessary Directories

```bash
# Create cache directory for zsh completions
mkdir -p ~/.zsh/cache

# Create notes directory (for note-taking functions)
mkdir -p ~/notes

# Create trash directory (for safe delete)
mkdir -p ~/.trash
```

### Step 5: Reload Your Shell

```bash
# Reload the configuration
source ~/.zshrc

# Or simply open a new terminal window
```

## ⚙️ Configuration

### Editor Setup

The configuration uses **Sublime Text** as the default editor. If you prefer **VS Code** or another editor, modify these lines in `.zshrc`:

```bash
# For VS Code
alias zshrc='code ~/.zshrc'
alias e='code .'
alias edit='code'

# For Sublime Text (default)
alias zshrc='subl ~/.zshrc'
alias s='subl .'
alias subl='subl'
```

### Customizing Aliases

You can customize any alias by editing `~/.zshrc`. After making changes, reload with:

```bash
reload
# or
source ~/.zshrc
```

### Adding Your Own Aliases

Add your custom aliases at the end of the `.zshrc` file:

```bash
# Custom aliases
alias myalias='my command'
```

## 📚 Key Features & Usage

### History Configuration

- **History Size**: 10,000 commands stored
- **Shared History**: All terminal sessions share the same history
- **Duplicate Prevention**: Duplicate commands are automatically ignored
- **Space Prefix**: Commands starting with space are not saved to history

**Usage:**
```bash
# Search history (Ctrl+R)
# Or use arrow keys to browse
history | grep "keyword"
```

### Completion System

- **Case-Insensitive**: Completions work regardless of case
- **Cached Completions**: Faster completion by caching results
- **Smart Matching**: Fuzzy matching for better completion suggestions

**Usage:**
- Press `Tab` to accept autosuggestion
- Press `Shift+Tab` for normal completion menu

### Key Bindings

- **Tab**: Accept autosuggestion
- **Ctrl+Right Arrow**: Move forward one word
- **Ctrl+Left Arrow**: Move backward one word

## 🔧 Aliases Reference

### Directory Navigation

```bash
.2        # Go up 2 directories
.3        # Go up 3 directories
.4        # Go up 4 directories
.5        # Go up 5 directories
work      # Navigate to ~/work
projects  # Navigate to ~/projects
downloads # Navigate to ~/Downloads
docs      # Navigate to ~/Documents
```

### Configuration Files

```bash
zshrc     # Open .zshrc in editor
reload    # Reload .zshrc configuration
hosts     # Edit /etc/hosts file
```

### Editor Shortcuts

```bash
e         # Open current directory in VS Code
edit      # Open file/folder in VS Code
s         # Open current directory in Sublime Text
subl      # Open file/folder in Sublime Text
```

### Git Aliases

```bash
gaa       # git add .
gcm       # git commit -m "message"
gca       # git commit --amend
gco       # git checkout
gcb       # git checkout -b
gpl       # git pull
gst       # git stash
gstp      # git stash pop
glog      # git log --oneline --decorate --graph --all
gwip      # git add . && git commit -m "WIP"
gnope     # git reset --hard && git clean -df (use with caution!)
```

### Docker Aliases

```bash
dcu       # docker-compose up -d
dcd       # docker-compose down
dcr       # docker-compose restart
dlog      # docker-compose logs -f
dstop     # docker stop $(docker ps -aq)
dclean    # docker system prune -af
```

### Kubernetes Aliases


#### General
```bash
k         # kubectl
kl        # kubectl logs
kexec     # kubectl exec -it
kpf       # kubectl port-forward
kaci      # kubectl auth can-i
kat       # kubectl attach
kapir     # kubectl api-resources
kapiv     # kubectl api-versions
```
#### Get commands
```bash
kg        # kubectl get
kgns      # kubectl get ns
kgp       # kubectl get pods
kgs       # kubectl get secrets
kgd       # kubectl get deploy
kgrs      # kubectl get rs
kgss      # kubectl get sts
kgds      # kubectl get ds
kgcm      # kubectl get configmap
kgcj      # kubectl get cronjob
kgj       # kubectl get job
kgsvc     # kubectl get svc -o wide
kgn       # kubectl get no -o wide
kgr       # kubectl get roles
kgrb      # kubectl get rolebindings
kgcr      # kubectl get clusterroles
kgsa      # kubectl get sa
kgnp      # kubectl get netpol
```

#### Edit commands
```bash
ke        # kubectl edit
kens      # kubectl edit ns
kes       # kubectl edit secrets
ked       # kubectl edit deploy
kers      # kubectl edit rs
kess      # kubectl edit sts
keds      # kubectl edit ds
kesvc     # kubectl edit svc
kecm      # kubectl edit cm
kecj      # kubectl edit cj
ker       # kubectl edit roles
kecr      # kubectl edit clusterroles
kerb      # kubectl edit clusterrolebindings
kesa      # kubectl edit sa
kenp      # kubectl edit netpol
```
#### Describe commands
```bash
kd        # kubectl describe
kdns      # kubectl describe ns
kdp       # kubectl describe pod
kds       # kubectl describe secrets
kdd       # kubectl describe deploy
kdrs      # kubectl describe rs
kdss      # kubectl describe sts
kdds      # kubectl describe ds
kdsvc     # kubectl describe svc
kdcm      # kubectl describe cm
kdcj      # kubectl describe cj
kdj       # kubectl describe job
kdsa      # kubectl describe sa
kdr       # kubectl describe roles
kdrb      # kubectl describe rolebindings
kdcr      # kubectl describe clusterroles
kdcrb     # kubectl describe clusterrolebindings
kdnp      # kubectl describe netpol
```
#### Delete commands
```bash
kdel      # kubectl delete
kdelns    # kubectl delete ns
kdels     # kubectl delete secrets
kdelp     # kubectl delete po
kdeld     # kubectl delete deployment
kdelrs    # kubectl delete rs
kdelss    # kubectl delete sts
kdelds    # kubectl delete ds
kdelsvc   # kubectl delete svc
kdelcm    # kubectl delete cm
kdelcj    # kubectl delete cj
kdelj     # kubectl delete job
kdelr     # kubectl delete roles
kdelrb    # kubectl delete rolebindings
kdelcr    # kubectl delete clusterroles
kdelsa    # kubectl delete sa
kdelnp    # kubectl delete netpol
```
#### Mock commands
```bash
kmock     # kubectl create mock -o yaml --dry-run=client
kmockns   # kubectl create ns mock -o yaml --dry-run=client
kmockcm   # kubectl create cm mock -o yaml --dry-run=client
kmocksa   # kubectl create sa mock -o yaml --dry-run=client
```
#### Config commands
```bash
kcfg      # kubectl config
kcfgv     # kubectl config view
kcfgns    # kubectl config set-context --current --namespace
kcfgcurrent # kubectl config current-context
kcfggc    # kubectl config get-contexts
kcfgsc    # kubectl config set-context
kcfguc    # kubectl config use-context
```
#### Kubescape related
```bash
kssbom    # kubectl -n kubescape get sbomspdxv2p3s
kssbomf   # kubectl -n kubescape get sbomspdxv2p3filtereds
kssboms   # kubectl -n kubescape get sbomsummaries
ksvulns   # kubectl -n kubescape get vulnerabilitymanifestsummaries
ksvuln    # kubectl -n kubescape get vulnerabilitymanifests
kssboml   # kubectl -n kubescape get sbomspdxv2p3s --show-labels
kssbomfl  # kubectl -n kubescape get sbomspdxv2p3filtereds --show-labels
kssbomsl  # kubectl -n kubescape get sbomsummaries --show-labels
ksvulnsl  # kubectl -n kubescape get vulnerabilitymanifestsummaries --show-labels
ksvulnl   # kubectl -n kubescape get vulnerabilitymanifests --show-labels
```

### System Monitoring

```bash
cpu       # Show processes sorted by CPU usage
mem       # Show processes sorted by memory usage
df        # Disk usage (human-readable)
du        # Directory size (human-readable, depth 1)
ports     # Show listening ports
myip      # Show public IP address
localip   # Show local IP address
```

### Network Utilities

```bash
speedtest # Run speed test
serve     # Start HTTP server on port 8000
```

## 🎯 Functions Reference

### File Management

```bash
mkcd <directory>           # Create directory and cd into it
extract <archive>          # Extract any archive type (.zip, .tar.gz, etc.)
compress <directory>       # Compress directory to .tar.gz
backup <file>              # Backup file with timestamp
trash <file>               # Move file to trash (safer than rm)
untrash <file>             # Restore file from trash
emptytrash                 # Empty trash directory
largest [n]                # Show n largest files (default: 10)
```

### Development Tools

```bash
findreplace 'old' 'new'    # Find and replace text in files
openf <pattern>            # Open files matching pattern
openg <text>               # Open files containing text (requires fzf)
fcd [directory]            # Fuzzy find and cd into directory (requires fzf)
fopen [directory]          # Fuzzy find and open file (requires fzf)
loc <extension>            # Count lines of code by extension
newproject <name>          # Create new project structure
```

### Text Processing

```bash
json                      # Format JSON (pipe JSON to this)
urlencode <text>          # URL encode text
urldecode <text>          # URL decode text
ccat <file>               # Colorized cat (requires pygments)
```

### Git Utilities

```bash
qc [message]              # Quick commit with optional message
```

### System Utilities

```bash
killp <process_name>      # Kill process by name
whatport <port>           # Find process using port
tmpd                      # Create and cd into temporary directory
usage                     # Show disk usage visualization
histats                   # Show most used commands
timer <seconds>           # Start a timer
remind <seconds> <msg>    # Set a reminder (requires notify-send)
```

### Web Utilities

```bash
weather [city]            # Quick weather (default: Bengaluru)
weatherfull [city]        # Full weather report
qr <text>                 # Generate QR code
ipinfo [ip]               # Get IP information
pingweb <url>             # Test website response time
dlsite <url>              # Download entire website
cheat <command>           # Get cheat sheet for command
define <word>             # Dictionary lookup
```

### Fun Commands

```bash
welcome                   # ASCII art welcome message
joke                      # Random joke
fact                      # Random fact
matrix                    # Matrix effect (requires cmatrix)
sysinfo                   # System info display (requires neofetch)
```

### Note Taking

```bash
note <text>               # Add note to daily note file
searchnotes <keyword>     # Search notes
```

### Media

```bash
vid2gif <input> <output>  # Convert video to GIF (requires ffmpeg)
```

## 🔒 Safety Features

The configuration includes several safety features to prevent accidental data loss:

- **Protected cp/mv**: Prompts before overwriting existing files
- **Safe rm**: Uses `rm -I` with confirmation prompt
- **Root Protection**: Prevents chmod/chown/chgrp on root directory
- **Trash System**: Use `trash` instead of `rm` for recoverable deletion

## ⚡ Performance Optimizations

This configuration is optimized for performance:

- **Lazy Loading**: Autosuggestions use completion strategy only
- **Cached Completions**: Completions are cached for faster response
- **Async Operations**: Autosuggestions run asynchronously
- **Disabled Slow Checks**: Security checks that slow down startup are disabled
- **Optimized History**: Efficient history management

## 🐛 Troubleshooting

### Issue: Powerlevel10k not showing correctly

**Solution:**
1. Ensure Powerlevel10k is installed correctly
2. Run `p10k configure` to regenerate configuration
3. Install recommended fonts: [Nerd Fonts](https://www.nerdfonts.com/)

### Issue: Autosuggestions not working

**Solution:**
1. Verify plugins are installed:
   ```bash
   ls -la ~/.oh-my-zsh/custom/plugins/
   ```
2. Ensure plugins are enabled in `.zshrc`
3. Reload configuration: `source ~/.zshrc`

### Issue: Functions not working (fzf, tree, etc.)

**Solution:**
- Install missing dependencies:
  ```bash
  # macOS
  brew install fzf tree

  # Linux
  sudo apt install fzf tree
  ```

### Issue: Editor shortcuts not working

**Solution:**
- Ensure your editor is installed and in PATH
- Update aliases in `.zshrc` to match your editor command
- For VS Code, ensure `code` command is available:
  ```bash
  # macOS: Install from VS Code Command Palette
  # Cmd+Shift+P -> "Shell Command: Install 'code' command in PATH"
  ```

### Issue: Slow shell startup

**Solution:**
- Check what's slowing down: `zsh -xv` (verbose mode)
- Disable unnecessary plugins
- Ensure completion cache is working: `ls -la ~/.zsh/cache`

### Issue: History not sharing across terminals

**Solution:**
- Verify `SHARE_HISTORY` option is enabled (it is by default)
- Check history file permissions: `ls -la ~/.zsh_history`
- Ensure you're using the same shell (zsh) in all terminals

## 📝 Customization Tips

### Adding Your Own Functions

Add custom functions at the end of `.zshrc`:

```bash
# Custom function example
myfunction() {
    echo "Hello from my function!"
}
```

### Changing Default Locations

Update these variables in `.zshrc`:

```bash
# Change notes directory
note() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$HOME/my-custom-notes/$(date '+%Y-%m-%d').txt"
  echo "Note saved!"
}
```

### Customizing Prompt

Run `p10k configure` to customize your Powerlevel10k prompt, or edit `~/.p10k.zsh` directly.

## 🔄 Updating

To update your `.zshrc` configuration:

```bash
# If using git repository
cd ~/zshrc-config
git pull
cp zshrc ~/.zshrc
source ~/.zshrc
```

## 📄 License

This configuration is provided as-is. Feel free to customize it for your needs.

## 🤝 Contributing

- Fork the repository
- Keep changes minimal and well-documented
- Submit focused pull requests

## 📞 Support

If you encounter issues or have questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review the [Oh My Zsh documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
3. Check [Powerlevel10k documentation](https://github.com/romkatv/powerlevel10k)

---

**Enjoy your enhanced terminal experience! 🚀**

