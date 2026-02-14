# Fedora Development Environment Setup

Automated setup script for C/C++/Rust/TypeScript development on Fedora 43.

## What it installs

- Development toolchains: gcc, clang, cmake, ninja
- Rust with rust-analyzer, clippy, rustfmt
- Node.js, pnpm, TypeScript LSP servers
- Neovim nightly (via bob version manager)
- zsh with Zap plugin manager
- CLI tools: zoxide, eza, fzf
- Nerd Fonts (JetBrains Mono, FiraCode, Hack)
- Homebrew

## Usage
```bash
chmod +x setup-fedora-dev.sh
./setup-fedora-dev.sh
```

Log out and back in after completion.

## Post-install

Verify installations:
```bash
gcc --version
clang --version
rustc --version
node --version
nvim --version
```

Terminal font should be set to JetBrainsMono Nerd Font.

## Manual configuration required

- Import your Neovim configs (PureNvim, LazyVim, etc.)
- Install terminal color scheme via Gogh: `bash -c "$(curl -sLo- https://git.io/vQgMr)"`
- Configure git: `git config --global user.name/user.email`

## Troubleshooting

If bob's nvim isn't found:
```bash
echo $PATH | grep bob
```

Should contain `~/.local/share/bob/nvim-bin`.

If not in zsh after reboot:
```bash
echo $SHELL
```

Should show `/usr/bin/zsh`.
