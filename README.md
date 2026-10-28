# dotfiles

macOS development environment configuration

## Content

- Neovim configuration (submodule)
- Fish shell configuration (submodule)
- Git configuration with delta integration
- Custom binaries and utilities
- Package management via [Homebrew Bundle](./Brewfile)
- Version managers:
  - asdf for Go, Java, Node, Ruby, and other runtimes
  - uv for Python versions and tools
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
- Configuring version managers (asdf)
- Setting up Neovim
- Installing Python tools via uv

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

## Private skills

`./install` includes the private skills stge. Use `./install --skills-only` to install skills without running Homebrew, Git profile setup or Neovim configuration. This mode requires existing Git/SSH authentication, Node.js, npm and uv.

`skills.lock.json` pins `kornicameister/skills` to a complete commit. The checkout lives at `~/.local/share/kornicameister/skills`. Dotbot is pinned indepnedently to v1.24.0 and always runs from this repository. Installation fails when a stage fails.

Use `./install --dry-run` or `./install --skills-only --dry-run` to preview Dotbot actions. Initialize the pinned Dotbot submodule first on a fresh checkout: `git submodule update --init -- dotbot`. Dry runs do not fetch repositories or install packages.

Skills are independent copies in `~/.claude/skills` and `~/.agents/skills`. Platform configuration remains linked. The migration preserves unrelated packages and platform-managed files, backs up previous directories, and refuses unknown packages or local edits. It removes only the reviewed AWS skill snapshots. AWS MCP configuration and plugins remain managed separately.

Each completed migration prints a rollback command. Backups and journals are under `~/.local/state/kornicameister/skills/backup-*`. Rollback refuses to overwrite later changes. See the private repository for interrupted-transaction recovery.

Bootstrap tests use local Git sources and temporary homes: `python -m pip install -r tests/requirements.txt`, then `python -m pytest tests -q`. Full-bootstrap tests replace package managers and application setup with fixtures. Installer conflict, migration and rollback tests live in the private skills repository. The `update-skills` skill follows migration acceptance.
