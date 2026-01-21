#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/jatingarg36/ZSHRC"
INSTALL_DIR="$HOME/.zshrc-config"
BIN_DIR="$HOME/.local/bin"
CMD_NAME="zsh-setup"

echo "Downloading ZSHRC setup..."
if [ -d "$INSTALL_DIR" ]; then
    echo "Directory $INSTALL_DIR already exists."
    echo "Updating..."
    cd "$INSTALL_DIR" && git pull
else
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Ensure ~/.local/bin exists
mkdir -p "$BIN_DIR"

# Create symlink
echo "Creating command '$CMD_NAME'..."
ln -sf "$INSTALL_DIR/setup.sh" "$BIN_DIR/$CMD_NAME"
chmod +x "$INSTALL_DIR/setup.sh"

echo
echo "✅ Installation successful!"
echo
echo "You can now run '$CMD_NAME' to configure your shell."
echo
echo "Available options:"
echo "  $CMD_NAME --list       # List available modules"
echo "  $CMD_NAME --dry-run    # Simulate installation"
echo "  $CMD_NAME --help       # Show help"
echo
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "⚠️  WARNING: $BIN_DIR is not in your PATH."
    echo "Add this to your shell config file (~/.bashrc, ~/.zshrc, etc.):"
    echo "  export PATH=\"$BIN_DIR:\$PATH\""
fi
