## Commit Convention

Always use FULL Conventional Commits (with scope) in every project.

### Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types
- feat: new feature (MINOR in semver)
- fix: bug fix (PATCH in semver)
- refactor: code change that neither fixes a bug nor adds a feature
- chore: maintenance, deps, tooling
- docs: documentation only
- style: formatting, no code change
- perf: performance improvement
- test: adding/fixing tests
- ci: CI/CD changes
- build: build system changes

### Scope
- Always include scope in parentheses describing the section of codebase
- Examples: feat(auth), fix(api), refactor(lsp), chore(deps)

### Breaking Changes
- Use `!` after type/scope: `feat(api)!: remove endpoint`
- Or use `BREAKING CHANGE:` footer
- Correlates with MAJOR in semver

### Rules
- Type is REQUIRED
- Scope is REQUIRED (full conventional commits)
- Description is REQUIRED, lowercase, no period at end
- Body is optional, separated by blank line
- Footer is optional, for breaking changes or references
