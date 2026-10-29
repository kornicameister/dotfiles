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

## Skills

Personal skills are maintained in the private [kornicameister/skills](https://github.com/kornicameister/skills) repository. It contains 11 personal packages, the pinned `find-docs` and `mastering-typescript` upstream snapshots, and platform-specific Graphify bundles. `registry.json` records their sources, versions and local additions. Official AWS skill packages are excluded; AWS MCP configuration and plugins remain separaate.

Dotfiles tracks `skills.lock.json`, which pins the private repository commit and the `tsx` runner. The TypeScript installer, its tests and type-checking tools belong to the private repository. The bootstrap uses `npx tsx` directly and needs no new `package.json`, npm lock or intalled dependencies in dotfiles.

```bash
./install                     # Full bootstrap, including skills
./install --skills-only       # Skills with existing Git/SSH access
./install --skills-only --dry-run
```

Skills-only mode requires Git, Node.js, npm/npx and uv. It does not run Homebrew, Git profile setup or Neovim configuration. Dotbot always runs from its pinned submodule. On a fresh checkout, initialize that submodule before a dry run:

```bash
git submodule update --init --recursive -- dotbot
```

The private checkout lives at `~/.local/share/kornicameister/skills`. Installation checks out the exact commit from the lock, stages packages through pinned `skills --copy` in a temporary home with telemetry disabled, then verifies conflicts before activation.

The bootstrap exposes the same checkout at `~/dev/my-skills` through an absolute symlink. Both paths share files, the Git branch, index and commts. Existing symlinks to this checkout are preserved, including relative links. A file, directory or symlink to another target at the development path stops installation without overwriting it. The alias is created only after the pinned checkout is ready. Both dry-run modes describe this step without changing HOME or fetching the repository.

Edit skills through either path. A dirty checkout blocks installation; a clean chckout can be switched to the commit in `skills.lock.json`. Commit local work before installing. To remove only the development alias, run `unlink ~/dev/my-skills`; the checkout and its files remain in place.

### Linked folders and local test skills

| Platform | Discovered directory | Backing directory in dotfiles |
| --- | --- | --- |
| Claude Code | `~/.claude/skills` | `claude/skills` |
| Codex | `~/.codex/skills` | `codex/skills` |

Both platfrom directories remain symlinks. Their installed packages are independent copies. During migration, managed Codex copies move from `~/.agents/skills`; unrelated skills there are preserved.

Each backing directory tracks a `.gitignore` with this default:

```gitignore
*
!.gitignore
```

Add a local test skill beside the installed ones, for example `codex/skills/local-demo/SKILL.md`. It is available locally without adding it to `kornicameister/skills` or tracking it in dotfiles. To version it temporarily, add exceptions to `codex/skills/.gitignore`:

```gitignore
!local-demo/
!local-demo/**
```

Use the equivalent Claude directory when testing there. The installer preserves unknown packages and `.gitignore` exceptions. A managed package with local edits, or an unknown package using a managed name, stops installation. Keep platform-managed `.system` and `synced`, caches, bytecode and backups out of the index.

### Changes, recovery and verification

Before editing skills or usiing a skill that will modify files, commit the existing affected files locally. Use `conventional-commits`; a backup does not replace this commit. Pushing is a separate decision and is not required for local work. A fresh machine can fetch a pinned private commit only after that commit has been pushed.

Installation errors stop the bootstrap. Backups and transaction journals live in `~/.local/state/kornicameister/skills/backup-*`. A completed installation prints its rollback command. Rollback refuses to overwrite later changes. Inspect the journal before recovering an interrupted installation; never remove a lock while its installer is running.

Bootstrap tests use local Git repositories, temporary homes and fixtures for package managers and application setup:

```bash
uvx --python 3.13 --with pytest-mock==3.17.0 --with faker==40.43.0 pytest@9.2.0 tests -q
```

The private repository owns installer tests and `./typecheck`. Its tests cover independent copies, conflicts, download failures, repeated installs, symlinks, preserved local files and rollback. Behavior scenarios are documented separately; instruction-preservation checks do not prove live agent behavior. The `update-skills` skill will be added after migration acceptance.

Keep client names, repository paths and project context out of shared `claude/settings.json`, especially `autoMode.environment`. Project-specific settings belong in an ignored project-local `.claude/settings.local.json`; never persist them in global dotfiles.

Shared `claude/settings.json` and `codex/config.toml` are clean templates, copied only when local settings are absent or still linked to those templates. Existing local files are preserved. Application writes, project trust and hook state remain outside Git. `~/.claude.json` is application-owned state and must never be linked into or tracked by dotfiles. Keep project-specific context out of shared templates.
