# tmux – A Practical Guide for Senior Developers

tmux (Terminal Multiplexer) is a foundational productivity tool for engineers who spend significant time in terminals, SSH sessions, and long-running workflows. This guide provides a **complete, no-nonsense reference** to tmux fundamentals, essential commands, and power-user practices—sufficient for a senior developer to confidently adopt tmux in daily work.

This repository already includes a `tmux.conf`. This README explains tmux **with that configuration in mind**, highlighting both default and enhanced workflows.

---

## Table of Contents

1. What is tmux and Why It Matters
2. Core Mental Model
3. Installation & First Use
4. Sessions
5. Windows
6. Panes
7. Prefix Key and Keybinding Philosophy
8. Copy Mode & Scrollback
9. Configuration (`tmux.conf`)
10. Daily Productivity Workflows
11. tmux over SSH (Critical Use Case)
12. Common Pitfalls & Best Practices
13. Next Steps

---

## 1. What is tmux and Why It Matters

tmux is a **terminal multiplexer**. It allows you to:
- Run multiple terminal sessions inside a single terminal window
- Split terminals into panes and windows
- Detach and reattach sessions at will
- Keep processes alive across SSH disconnects, terminal crashes, or network drops

For senior developers, tmux is not a convenience—it is **infrastructure for focus and reliability**.

---

## 2. Core Mental Model

tmux has a strict hierarchy:

```
Session
├── Window
│    ├── Pane
│    └── Pane
└── Window
    └── Pane
```

### Key Concepts
- **Session**: Project-level workspace (e.g., `backend`, `infra`, `k8s-debug`)
- **Window**: Task-level context (editor, server, logs)
- **Pane**: Parallel views inside a window

If you internalize this model, tmux becomes intuitive.

---

## 3. Installation & First Use

### Install

```bash
# macOS
brew install tmux

# Debian / Ubuntu
sudo apt install tmux
```

### Start tmux

```bash
tmux
```

You are now inside a tmux session.

⸻

## 4. Sessions (The Most Important Feature)

### Create a Session

```bash
tmux new -s backend
```

### Detach (leave session running)

```
Ctrl + b d
```

### List Sessions

```bash
tmux ls
```

### Attach to a Session

```bash
tmux attach -t backend
```

### Kill a Session

```bash
tmux kill-session -t backend
```

**Rule**: One tmux session per project.

⸻

## 5. Windows (Task Isolation)

Windows are equivalent to terminal tabs.

### Create Window

```
Ctrl + b c
```

### Rename Window

```
Ctrl + b ,
```

### Switch Windows

```
Ctrl + b 0–9
```

### Close Window

```bash
exit
```

### Recommended Convention

- editor
- server
- logs
- db
- k8s


## 6. Panes (Parallel Work)

Panes allow multiple shells in the same window.

### Split Panes

```
Ctrl + b %    # vertical split
Ctrl + b "    # horizontal split
```

### Navigate Panes

```
Ctrl + b ← ↑ ↓ →
```

### Zoom Pane

```
Ctrl + b z
```

### Close Pane

```bash
exit
```

Panes are ideal for logs, watchers, REPLs, and monitors.

⸻

## 7. Prefix Key & Keybinding Philosophy

By default, tmux uses:

**Prefix**: `Ctrl + b`

All tmux commands are issued after the prefix.

**Example**:

```
Ctrl + b c   # create window
```

### With tmux.conf

This repository's `tmux.conf` rebinds and optimizes keys, typically to:

- Use `Ctrl + a` as prefix (lower finger travel)
- Enable Vim-style navigation (h/j/k/l)
- Add repeatable resize keys
- Enable mouse support

👉 Always review `tmux.conf` first to understand your active bindings.

## 8. Copy Mode & Scrollback (Vim-Style)

tmux maintains its own scrollback buffer.

### Enter Copy Mode

```
Ctrl + b [
```

### Common Keys

```
j / k     → scroll
Space     → start selection
Enter     → copy selection
Ctrl + b ] → paste
```

With Vim keybindings enabled in `tmux.conf`, copy mode becomes fast and predictable.

⸻

## 9. Configuration (tmux.conf)

tmux behavior is controlled via:

```
~/.tmux.conf
```

This repository already contains a power-user configuration, which typically includes:

- Mouse support
- Faster key response
- Vim-style pane navigation
- Improved status bar
- Window & pane indexing from 1
- Better copy-mode defaults

### Reload Configuration

```
Ctrl + a R
```

(or equivalent, depending on config)

Treat `tmux.conf` as code. Small changes compound productivity gains.


## 10. Daily Productivity Workflows

### Backend Development Example

```
Session: backend
 ├── editor   → vim / nvim
 ├── server   → app server
 ├── logs     → tail -f / structured logs
 └── infra    → docker / kubectl
```

### Debugging Workflow

- Panes for logs, REPL, shell
- Zoom (z) to focus
- Copy mode to extract stack traces


## 11. tmux over SSH (Critical Use Case)

**Best practice**:

```bash
ssh server
tmux attach || tmux new
```

**Benefits**:

- SSH drops do not kill processes
- Long builds and deploys are safe
- Reattach from anywhere

This alone justifies tmux adoption.


## 12. Common Pitfalls & Best Practices

### Pitfalls

- Treating tmux like a GUI terminal
- Overusing panes instead of windows
- Not naming windows
- Ignoring `tmux.conf`

### Best Practices

- One session per project
- Windows for tasks, panes for context
- Learn detach/attach by muscle memory
- Keep `tmux.conf` minimal and intentional


## 13. Next Steps

Once comfortable with this guide:

- Add plugins (tmux-resurrect, continuum)
- Create project-specific layouts
- Integrate tmux with Vim/Neovim
- Use tmux for Docker & Kubernetes workflows

At this point, tmux becomes a force multiplier, not just a terminal tool.


## Final Note

tmux is not about learning commands—it’s about owning your execution environment.
Used correctly, it removes friction, reduces cognitive load, and protects your work.

Master it once. Benefit for years.
