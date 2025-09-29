# Conventional Commits Configuration

This directory contains the configurations and hooks to ensure all commits follow the [Conventional Commits](https://www.conventionalcommits.org/) standard.

## Files

- **commit-msg**: Hook that validates commit format
- **pre-commit**: Hook that runs checks before commit (future)

## Configuration

The `commit-msg` hook automatically validates:

1. **Format**: `<type>[optional scope]: <description>`
2. **Valid types**: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
3. **Length**: Maximum 100 characters on first line
4. **Style**: Lowercase description, no period at end
5. **Breaking changes**: Indicated with `!` after type/scope

## Valid Examples

```
feat(userspace): add ARM64 cross-compilation support
fix(build): resolve MAKEOBJDIRPREFIX path issues
docs(readme): update installation instructions
style: format shell scripts with consistent indentation
refactor(scripts): improve error handling in build.sh
perf(build): optimize parallel job allocation
test: add validation for userspace extraction
build(deps): update FreeBSD submodule to latest
ci: add GitHub Actions workflow
chore: update .gitignore patterns
revert: revert "feat: experimental feature"
```

## Invalid Examples

```
❌ Add new feature                    # No type
❌ feat: Add new feature              # Uppercase description
❌ feat: add new feature.             # Period at end of description
❌ feature: add new feature           # Invalid type
❌ feat(userspace): this is a very long description that exceeds the maximum allowed length for commit messages
```

## Breaking Changes

For changes that break compatibility:

```
feat!: remove deprecated API endpoints
feat(api)!: change authentication method

BREAKING CHANGE: The authentication method has changed from tokens to OAuth2.
```