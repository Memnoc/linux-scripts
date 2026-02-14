#!/bin/bash

set -e

echo "Installing development tools..."
sudo dnf groupinstall -y "Development Tools" "Development Libraries"
sudo dnf install -y gcc gcc-c++ clang lldb gdb cmake ninja-build pkg-config \
    clang-tools-extra openssl-devel libcurl-devel sqlite-devel \
    zsh fzf

echo "Installing Rust..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi
rustup component add rust-analyzer clippy rustfmt

echo "Installing Node.js and pnpm..."
sudo dnf install -y nodejs npm
npm install -g pnpm
pnpm setup

echo "Installing Rust tools..."
cargo install zoxide eza bob-nvim

echo "Installing Neovim via bob..."
bob install nightly
bob use nightly

echo "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Installing TypeScript tools..."
pnpm install -g typescript typescript-language-server prettier eslint

echo "Installing Zap plugin manager..."
if [ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zap" ]; then
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
fi

echo "Installing Nerd Fonts..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrains Mono Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
curl -fLo "Fira Code Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
curl -fLo "Hack Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf
fc-cache -fv

echo "Creating .zshrc..."
cat > ~/.zshrc << 'EOF'
# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Init zoxide
eval "$(zoxide init zsh)"

# User configuration
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=KickstartNeovim nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"

# Neovim distros control
function nvims() {
  items=("default" "KickstartNeovim" "LazyVim" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s "\C-a" "nvims"

# omz
alias zshconfig="geany ~/.zshrc"
alias ohmyzsh="thunar ~/.oh-my-zsh"

# ls
alias l='ls -lh'
alias ll='ls -lah'
alias la='ls -A'
alias lm='ls -m'
alias lr='ls -R'
alias lg='ls -l --group-directories-first'

# go
alias gr='go run .'
alias gmi='go mod init'
alias gmt='go mod tidy'
alias grc='go run -gcflags -m .'

# terminal
alias cl='clear'
alias th='touch'
alias mk='mkdir'
alias ls='eza -lag --icons --color=always --group-directories-first --no-git --no-permissions --grid --hyperlink --header --time-style=iso --sort=size'
alias lg='eza -lag --icons --color=always --group-directories-first --grid --hyperlink --header --git --git-ignore --sort=modified --no-permissions --git-repos'
alias tr='echo $PATH | tr : '\n''

# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gpu='git push -u origin main'
alias gp='git push'
alias gst='git status'

#rust
alias cr='cargo run'
alias cb='cargo build'
alias cn='cargo new'
alias cc='cargo check'
alias cbr='cargo build --release'
alias cws='cargo watch -w src -x run'
alias ct='cargo test'
alias tree='tree -I target'

# pnpm
alias p='pnpm install'
alias pd='pnpm dlx'
alias pa='pnpm add'

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# PATH
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fpath+=${ZDOTDIR:-~}/.zsh_functions

# pnpm
export PNPM_HOME="/home/memnoc/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
EOF

echo "Configuring Gnome Terminal..."
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'JetBrainsMono Nerd Font 11'

echo "Changing default shell to zsh..."
chsh -s $(which zsh)

echo "Setup complete. Log out and back in for zsh to take effect."
