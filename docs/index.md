# 🛠️ ZSHRC – Interactive Zsh Setup & Tooling

Welcome 👋  
This project helps you **set up a powerful Zsh-based development environment** in a **safe, modular, and explainable way**.

It is designed for:
- Developers setting up a new machine
- Engineers who want control over what gets installed
- Anyone tired of copy-pasting random dotfiles

---

## 🚀 Quick Navigation

- [Getting Started](#-getting-started)
- [What This Project Does](#-what-this-project-does)
- [How It Works](#-how-it-works)
- [Common Commands](#-common-commands)
- [Modules Overview](#-modules-overview)
- [Shell Setup (Zsh)](#-shell-setup-zsh)
- [Troubleshooting](#-troubleshooting)
- [Resources](#-resources)

---

## ✨ What This Project Does

This repository provides an **interactive setup system** that lets you:

- Install tools like `zsh`, `tmux`, `fzf`, and more
- Apply `.zshrc` and `.tmux.conf` safely
- Understand **dependencies between tools**
- Preview changes before installing
- Run the setup multiple times without breaking your system

> Nothing is installed silently. Everything is explicit.

---

## 🧠 How It Works

- Each tool or configuration is treated as a **module**
- Modules declare their **dependencies**
- The installer resolves dependencies automatically
- If something is skipped or missing, dependent modules are skipped safely
- Configuration files are **always updated with backups**

You can explore this visually using the dependency graph.

---

## 🟢 Getting Started

### Clone the repository

```bash
git clone https://github.com/jatingarg36/ZSHRC
cd ZSHRC
chmod +x setup.sh
```
### Run the setup (recommended)

```bash
./setup.sh
```
This launches an interactive menu where you choose what to install.

---

## ⚡ Common Commands

### Install everything (non-interactive)
```bash
./setup.sh --yes
```
### Preview without installing (dry run)
```bash
./setup.sh --dry-run
```
### Install specific modules
```bash
./setup.sh tmux fzf config
```
### Visualize dependency graph
```bash
./setup.sh --graph
```
### Explain a module
```bash
./setup.sh --explain tmux
```

---

## 🧩 Modules Overview

Some of the key modules included:
	•	zsh – Z shell
	•	ohmyzsh – Zsh framework
	•	p10k – Powerlevel10k theme
	•	tmux – Terminal multiplexer
	•	fzf – Fuzzy finder
	•	zsh-autosuggestions
	•	zsh-syntax-highlighting
	•	config – Installs .zshrc, .tmux.conf, and directories

You can list all available modules anytime:
```bash
./setup.sh --list
```

---

## 🐚 Shell Setup (Zsh)

For safety reasons, the installer does not change your default shell automatically.

If you explicitly want to switch your default shell to Zsh:
```bash
./setup.sh --set-shell
```
Or as part of full setup:
```bash
./setup.sh --yes --set-shell
```
After that, restart your terminal or run:
```bash
exec zsh
```

---

## 🧪 CI / Automation Safety

In CI environments (GitHub Actions, GitLab CI, containers):
	•	Shell changes are automatically skipped
	•	The installer never fails because of chsh

This makes the project safe for automation.

---

## 🧯 Troubleshooting

### "My shell is still bash"

This is expected.
Run:
```bash
./setup.sh --set-shell
```
### "Nothing changed after re-running setup"

Try:
```bash
./setup.sh config
```
Config modules always re-apply updates with backups.

---

## 🔗 Resources

Useful links to understand the tools used here:
	•	Zsh: https://www.zsh.org/
	•	Oh My Zsh: https://ohmyz.sh/
	•	Powerlevel10k: https://github.com/romkatv/powerlevel10k
	•	Nerd Fonts (required for p10k): https://www.nerdfonts.com/
	•	tmux: https://github.com/tmux/tmux
	•	GitHub Pages: https://pages.github.com/

---

## 🤝 Contributing

Contributions are welcome!
Please see CONTRIBUTING.md￼.

---

## 📌 Project Links

* GitHub Repository: https://github.com/jatingarg36/ZSHRC
* Issues & Suggestions: https://github.com/jatingarg36/ZSHRC/issues
