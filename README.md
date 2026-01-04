# Enhanced Zsh Configuration

A **minimal, fast, and safe configuration** designed for developers who want a powerful terminal without unnecessary bloat. Built on **Oh My Zsh** and **Powerlevel10k**, with sensible defaults, productivity aliases, and safety-focused behavior.

> 📖 **For comprehensive documentation**, including detailed aliases reference, functions guide, troubleshooting tips, and customization examples, see [README-detailed.md](README-detailed.md).

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

---

## 📑 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Minimal Setup](#-minimal-setup)
- [Configuration](#-configuration)
- [Aliases & Functions](#-aliases--functions)
- [Safety & Performance](#-safety--performance)
- [Troubleshooting](#-troubleshooting)
- [Updating](#-updating)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

- Fast **Powerlevel10k** prompt
- Smart autosuggestions & syntax highlighting
- Optimized startup with caching & lazy loading
- Git, Docker, system, and navigation aliases
- Safe defaults to avoid accidental data loss

---

## 📋 Requirements

### Required

- **Zsh ≥ 5.0.8**
- **Oh My Zsh**
- **Powerlevel10k** theme
- **zsh-autosuggestions** plugin
- **zsh-syntax-highlighting** plugin

### Recommended

- **Nerd Font** (required for prompt icons) [https://www.nerdfonts.com/](https://www.nerdfonts.com/)

### Optional

- `tmux` - Terminal multiplexer (configuration file will be installed automatically)
- `fzf`, `tree`, `neofetch`, `ffmpeg`, `pygments`, `cmatrix`, `speedtest-cli`
- `cowsay`, `lolcat` (macOS only, installed via Homebrew by setup script)

---

## 🚀 Installation

### 1. Backup existing config

```bash
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

### 2. Install

```bash
git clone https://github.com/jatingarg36/ZSHRC.git ~/zshrc-config
cd ~/zshrc-config
cp zshrc ~/.zshrc
```

### 3. Configure prompt

```bash
p10k configure
```

### 4. Reload

```bash
source ~/.zshrc
```

---

## ⚡ Minimal Setup

If you want the fastest and cleanest experience:

- Enable only these plugins:
  - `git`
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
- Skip optional tools (`fzf`, `neofetch`, fun commands)

---

## ⚙️ Configuration

### Editor

Default editor is **Sublime Text**. For **VS Code**:

```bash
alias zshrc='code ~/.zshrc'
alias e='code .'
alias edit='code'
```

Reload after changes:

```bash
reload
```

---

## 🔧 Aliases & Functions

### ⚠️ Destructive (use carefully)

```bash
gnope       # git reset --hard && git clean -df
dclean      # docker system prune -af
dstop       # stop all containers
emptytrash  # permanently delete ~/.trash
```

### Common

```bash
# Navigation
.2 .3 .4 .5

# Git
gaa gcm gco gcb gpl gst glog gwip

# System
cpu mem ports myip localip
```

### Functions (examples)

```bash
mkcd extract backup trash json weather
```

> Linux only: `remind` requires `notify-send`

---

## 🔒 Safety & Performance

- Safe `rm` with confirmation
- Protected overwrite for `cp` / `mv`
- Trash-based deletion
- Cached completions
- Lazy-loaded plugins

---

## 🐛 Troubleshooting

### Prompt icons missing

- Install a Nerd Font
- Re-run `p10k configure`

### Slow startup

```bash
zsh -xv
```

Disable unused plugins or optional tools.

---

## 🔄 Updating

```bash
cd ~/zshrc-config
git pull
cp zshrc ~/.zshrc
source ~/.zshrc
```

---

## 🤝 Contributing

- Fork the repository
- Keep changes minimal and well-documented
- Submit focused pull requests

---

## 📄 License

This configuration is provided as-is. Feel free to customize it for your needs.

---

**Simple. Fast. Safe. Enjoy your Zsh ⚡**

