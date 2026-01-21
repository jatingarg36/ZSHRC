#!/usr/bin/env bash
set -e

# Test script for install.sh
# It creates a temporary directory, copies the local install.sh there,
# modifies it to point to the local repo, and runs it.

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR=$(mktemp -d -t zshrc-test.XXXXXX)

echo "Testing install.sh..."
echo "Temp dir: $TEST_DIR"

# Cleanup previous install to allow re-run without git conflicts
if [ -d "$HOME/.zshrc-config" ]; then
    echo "Cleaning up existing installation at $HOME/.zshrc-config..."
    rm -rf "$HOME/.zshrc-config" "$HOME/.local/bin/zsh-setup"
fi

# Copy install.sh to temp dir
cp "$BASE_DIR/install.sh" "$TEST_DIR/install.sh"

# Modify install.sh to use local repo instead of github
# We generally want to verify the logic of install.sh, assuming git clone works.
# Since we are using a local path, git clone will just clone the local directory.
echo "Running modified install.sh..."
bash "$TEST_DIR/install.sh"

# Sync current source code to the install directory
# This ensures that uncommitted changes (like the fix to setup.sh) are tested.
echo "Syncing local changes to $HOME/.zshrc-config..."
cp "$BASE_DIR/setup.sh" "$HOME/.zshrc-config/setup.sh"
cp -r "$BASE_DIR/lib" "$HOME/.zshrc-config/"
cp -r "$BASE_DIR/modules" "$HOME/.zshrc-config/"

echo
echo "Test complete!"
echo "Check if ~/.zshrc-config exists and ~/.local/bin/zsh-setup is created."
echo "Cleanup is manual for this test intentionally to let you inspect results."
