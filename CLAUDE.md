# Dotfiles development

## Skills

The private repository `kornicameister/skills` owns personal skill packages, upstream snapshots, the TypeScript installer, its tests and type checking. Dotfiles owns the bootstrap, platform configuration and `skills.lock.json`. Do not copy installer code or dependency manifests into dotfiles.

Run `./install --skills-only` to install the pinned skills without Homebrew, Git profile setup or Neovim configuration. Full `./install` runs the same Dotbot skills stage. The bootstrap prepares `~/.local/share/kornicameister/skills` at the exact commit in the lock, then invokes its `install.ts` through pinned `npx tsx`. Never update pins during an ordinary install.

Use `~/dev/my-skills` as the development path for `~/.local/share/kornicameister/skills`. These paths share one checkout, including the Git branch, index and commits. Do not create another clone or worktree or move the managed checkout. Preserve correct absolute or relative aliases and stop on conflicts. Dirty checkouts block installation; clean checkouts may return to the locked commit. Removing only the alias leaves the checkout intact.

Keep these independent platform directories linked to dotfiles:

- `~/.claude/skills` points to `claude/skills`.
- `~/.codex/skills` points to `codex/skills`.

The skills CLI uses a temporary home with `--copy`; the installer places the resulting copies into these backing directories. Managed Codex coies are removed from the former `~/.agents/skills` location during migration. Preserve unrelated skills there.

Each backing directory contains a tracked `.gitignore` that ignores installed content by default. Preserve this file and any local exceptions. Local test skills may live beside installed packages without belonging to the priivate repository. Never overwrite unknown packages or local edits; stop on a name conflict.

Keep raw installed packages, `.system`, `synced`, caches, bytecode and backups out of the Git index. Do not remove the directory symlinks or replace them with links between Claude and Codex. To version a local test skill, add both its directory and contents as exceptions in that directory's `.gitignore`.

Before changing skills or invoking a skill that will modify files, make a normal local commit of the existing affected files. A backup branch or filesystem copy does not satisfy this rule. Use `conventional-commits` before every commit. Preserve unrelated stageed work. Do not push unless requested.

Retain the migration journal and backups under `~/.local/state/kornicameister/skills`. Rollback must refuse to overwrite changes made after installation. Keep AWS MCP configuration and independent plugins; do not reinstall the removed official AWS skill packages.

The `update-skills` skill follows migration acceptance. It must require human approval before activating behavior, code or permission changes, preserve local additions, and use this same pinned installation mechanism.

See `README.md` for usage and test commands. It is not automatically imported into this instruction file.

Keep client names, repository paths and project context out of shared `claude/settings.json`, especially `autoMode.environment`. Project-specific settings belong in an ignored project-local `.claude/settings.local.json`; never persist them in global dotfiles.

Shared `claude/settings.json` and `codex/config.toml` are clean templates, copied only when local settings are absent or still linked to those templates. Existing local files are preserved. Application writes, project trust and hook state remain outside Git. `~/.claude.json` is application-owned state and must never be linked into or tracked by dotfiles. Keep project-specific context out of shared templates.
