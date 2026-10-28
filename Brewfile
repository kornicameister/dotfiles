# https://github.com/Homebrew/homebrew-bundle

tap "homebrew/bundle"
tap "homebrew/services"
tap "aws/tap"
tap "common-fate/granted"
tap "fugue/regula"
tap "hashicorp/tap"
tap "ankitpokhrel/jira-cli"
tap "jesseduffield/lazygit"
tap "lucagrulla/tap"

# Base packages
brew "openssl"
brew "coreutils"
# Keep GNU Parallel as parallel while exposing the other moreutils commands.
brew "moreutils", link: false, postinstall: <<~'SHELL'
  set -eu

  moreutils_binary_directory="$(brew --prefix moreutils)/bin"
  user_binary_directory="$HOME/.local/bin"
  mkdir -p "$user_binary_directory"

  for moreutils_binary in "$moreutils_binary_directory"/*; do
    binary_name="${moreutils_binary##*/}"
    [ "$binary_name" = parallel ] && continue
    destination="$user_binary_directory/$binary_name"

    if [ -L "$destination" ]; then
      [ "$(readlink "$destination")" = "$moreutils_binary" ] && continue
    elif [ ! -e "$destination" ]; then
      ln -s "$moreutils_binary" "$destination"
      continue
    fi

    printf 'Cannot link moreutils: %s already exists with a different target\n' "$destination" >&2
    exit 1
  done
SHELL
brew "findutils"
brew "wget"
brew "curl"
brew "cmake"
brew "gnu-sed"

# Shell
brew "fish", args: ['HEAD']
brew "starship"
brew "zsh"

# Version managers
brew "asdf"

# Development - Git
brew "git"
brew "git-extras"
brew "git-lfs"
brew "git-filter-repo"
brew "git-delta"
brew "ggshield"
brew "lazygit"
brew "gh"   # github cli
brew "glab" # gitlab cli

# Development - Languages
brew "rust"
brew "ruby"
brew "lua"
brew "luarocks"
brew "maven"
brew "composer"

# Development - Tools
brew "watch"
brew "ccache"
brew "jq"
brew "jo"
brew "yq"
brew "shellcheck"
brew "shfmt"
brew "stylua"
brew "exiftool"
brew "cloc"
brew "efm-langserver"
brew "neovim", args: ['HEAD']
brew "tree-sitter-cli"
cask "visual-studio-code"

# Python tools
brew "uv"

# JavaScript tools
brew "bun"

# Java
cask "temurin"

# Virtualization & Containers
brew "ctop"
brew "hadolint"
brew "kind"
brew "helm"
cask "orbstack"

# Browsers

# Utilities - CLI
brew "aria2"
brew "bat"
brew "direnv"
brew "eza"
brew "fd"
brew "fzf"
brew "glow"
brew "gnupg"
brew "htop"
brew "jira-cli"
brew "nmap"
brew "openssh"
brew "p7zip"
brew "ripgrep"
brew "timg"
brew "viddy"
brew "zoxide"
brew "lnav"
brew "parallel"
brew "rclone"
brew "grc"

# Utilities - GUI
cask "google-drive"
cask "openvpn-connect"
cask "protonvpn"
cask "macs-fan-control"

# Fonts
cask "font-iosevka"
cask "font-fontawesome"
cask "font-material-icons"
cask "font-hack-nerd-font"
cask "font-awesome-terminal-fonts"

# AI tools

# Cloud - AWS
brew "aws-sam-cli"
brew "cfn-flip"
brew "cfn-lint"
brew "regula"
brew "granted"
brew "lucagrulla/tap/cw"
# session-manager-plugin -> brew_formula/aws_session_manager.rb (local formula)

# Cloud - Google
cask "gcloud-cli"

# Cloud - Terraform
brew "hashicorp/tap/terraform"
brew "hashicorp/tap/terraform-ls"

# Productivity
cask "signal"
cask "slack"
cask "microsoft-teams"

# Database
brew "pgcli"

# Web servers
brew "httpd"

# Other tools
brew "mike-engel/jwt-cli/jwt-cli", args: ["HEAD"]
brew "graphviz"

brew "the_silver_searcher"
cask "temurin@8"

brew "prettyping"
