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
  - asdf for Go, Java, Node, Ruby, and other runtimes
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
- Python tools:
  - mypy (type checker)
  - flake8 (linter)
  - yapf (formatter)

## Installation

Run the [install](./install) script to set up the environment. The script handles:
- Installing packages via Homebrew
- Creating symlinks via dotbot
- Configuring version managers (pyenv, asdf)
- Setting up Neovim
- Installing Python packages via pipx

## Structure

```
.
├── aws/                    # Amazon Q configuration
├── bin/                    # Custom scripts
├── config/
│   ├── fish/              # Fish shell (submodule)
│   ├── nvim/              # Neovim (submodule)
│   ├── mypy/              # Python type checker config
│   ├── yapf/              # Python formatter config
│   └── flake8             # Python linter config
├── git_template/          # Git hooks
├── ssh/                   # SSH configuration
├── Brewfile               # Homebrew packages
├── gitconfig              # Git configuration
├── gitignore              # Global gitignore
└── install                # Installation script
```

## CI

Dotfiles are validated via GitHub Actions to ensure clean deployment on fresh systems.

## Credits

- [SSH Compression](https://www.gidblog.com/enable-compression-for-ssh/)
