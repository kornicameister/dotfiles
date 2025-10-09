[![time tracker](https://wakatime.com/badge/github/kornicameister/dotfiles.svg)](https://wakatime.com/badge/github/kornicameister/dotfiles)

# dotfiles

macOS development environment configuration

## Content

- Neovim configuration (submodule)
- Fish shell configuration (submodule)
- Git configuration with delta integration
- Custom binaries and utilities
- Package management via [Homebrew Bundle](./Brewfile)
- Version managers:
  - pyenv + pyenv-virtualenv for Python
  - goenv for Go (submodule)
  - asdf for Java, Node, and other runtimes
- Development tools:
  - Docker (OrbStack)
  - Kubernetes (kind, helm)
  - AWS CLI and tools
  - Terraform
- Browsers:
  - Brave
  - Google Chrome
  - Arc
- AI tools:
  - Amazon Q
  - Cursor
  - Claude Code

## Installation

Run the [install](./install) script to set up the environment. The script handles:
- Installing packages via Homebrew
- Creating symlinks via dotbot
- Configuring version managers
- Setting up Neovim
- Installing Python/Node/Go packages

## CI

Dotfiles are validated via GitHub Actions to ensure clean deployment on fresh systems.

## Credits

- [SSH Compression](https://www.gidblog.com/enable-compression-for-ssh/)
