To clone the bare repo, run the bash script below:

#!/bin/bash

# Set variables
DOTFILES_REPO_URL="git@github.com:hemantsharma1498/dot-files.git"  # CHANGE THIS
DOTFILES_DIR="$HOME/.cfg"
WORK_TREE="$HOME"

# Function to prompt user for overwrite
backup_if_conflict() {
    local file=$1
    if [ -e "$file" ]; then
        echo "⚠️  Conflict: $file already exists."
        read -p "Do you want to back it up to $file.backup and overwrite? [y/N]: " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            mv "$file" "$file.backup"
            echo "✔️  Backed up $file to $file.backup"
        else
            echo "⛔️ Skipping $file"
            return 1
        fi
    fi
    return 0
}

# Clone the bare repo
echo "📦 Cloning dotfiles from $DOTFILES_REPO_URL into bare repo at $DOTFILES_DIR..."
git clone --bare "$DOTFILES_REPO_URL" "$DOTFILES_DIR"

# Define config alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Check out working tree safely
echo "🧹 Attempting to check out dotfiles..."
mkdir -p .dotfiles-backup
config checkout 2>&1 | while read -r line; do
    if [[ "$line" =~ "^\s+([^:]+):\s+overwritten" ]]; then
        file="$WORK_TREE/${BASH_REMATCH[1]}"
        backup_if_conflict "$file" && config checkout "$file"
    elif [[ "$line" =~ "^\s+([^ ]+)\s+would be overwritten" ]]; then
        file="$WORK_TREE/${BASH_REMATCH[1]}"
        backup_if_conflict "$file" && config checkout "$file"
    fi
done

# One-time config setup
echo "⚙️  Setting config to hide untracked files..."
config config --local status.showUntrackedFiles no

# Add alias to shell config if not present
if ! grep -q "alias config=" "$HOME/.zshrc"; then
    echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> "$HOME/.zshrc"
    echo "🔧 Added config alias to .zshrc"
fi

echo "✅ Dotfiles setup complete!"
