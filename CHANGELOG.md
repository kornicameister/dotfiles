# Changelog

## 2025-01 - macOS Migration & Cleanup

### Major Changes

#### Version Manager Migration
- **Removed goenv** - Migrated Go version management to asdf
- Removed goenv submodule and all references from install scripts
- Updated README and Brewfile to reflect asdf for Go, Java, Node, Ruby

#### Linux-Specific Configuration Removal
- **Window Managers**: Removed i3, polybar, rofi configurations
- **System Tools**: Removed dunst (notification daemon), systemd, ranger
- **X11 & PAM**: Removed .XResources and .pam_environment
- **Docker**: Removed etc/docker/daemon.json (OrbStack doesn't use it)
- **Terminal**: Removed iTerm2 configuration

#### Dependency Cleanup
- Removed jenv (using asdf for Java)
- Removed zinit (not using zsh)
- Removed xxenv-latest (no longer needed)
- Removed nodenv references (using asdf)
- Removed pyenv references from some configs

#### Brewfile Improvements
- Reorganized with clear categories (Shell, Development, Cloud, etc.)
- Added 26 missing installed packages:
  - Shell: starship, zsh
  - Languages: luarocks, composer
  - Dev tools: cloc, markdownlint-cli, efm-langserver
  - Python: uv
  - Utilities: lnav, parallel, rclone, grc
  - AWS: granted, cw
  - Cloud: serverless
  - Productivity: spicetify-cli
  - Database: pgcli
  - Web servers: caddy, httpd
  - Other: graphviz
- Removed duplicate ripgrep entry
- Marked obsolete packages for future removal

#### Git Configuration
- Consolidated core config sections
- Added 'head' alias for detailed last commit view
- Expanded gitignore with tool versions and sensitive directories

#### Amazon Q Integration
- Added Amazon Q configuration tracking
- Added agents and prompts folders
- Updated install.conf.yaml to symlink both folders

#### Documentation
- Modernized README for macOS-only setup
- Added directory structure overview
- Updated installation steps
- Added Python tools section (mypy, flake8, yapf)

#### Scripts & Binaries
- Removed obsolete bin/upgrade script
- Removed bin/top_mem (not working on macOS, htop is better)
- Removed upgrade binary screenshot

#### Install Configuration
- Cleaned up install.conf.yaml
- Removed references to deleted Linux files
- Added Amazon Q agents folder symlink
- Removed Docker daemon installation step

### Files Removed
- All Linux window manager configs (i3, polybar, rofi, dunst, systemd, ranger)
- X11 and PAM configuration files
- Docker daemon configuration
- iTerm2 configuration
- Obsolete dependency submodules (goenv, jenv, zinit, xxenv-latest)
- Arch Linux installer
- CircleCI verify script
- Obsolete binaries and screenshots

### Configuration Updates
- Fish shell: Removed goenv initialization
- Git: Consolidated configuration, added aliases
- Install scripts: Removed goenv, jenv, nodenv configuration functions
- Brewfile: Reorganized and added missing packages

### Result
- Clean macOS-focused dotfiles
- All Linux-specific configurations removed
- Better organized Brewfile with all installed packages tracked
- Updated documentation reflecting current state
- Streamlined installation process

## Historical Context

This repository has evolved from a Linux (Arch/Ubuntu) setup to a macOS-focused development environment. The 2025-01 cleanup removed all Linux-specific configurations and modernized the setup for macOS with OrbStack, asdf, and current development tools.
