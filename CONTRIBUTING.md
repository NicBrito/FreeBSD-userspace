# Contributing to FreeBSD-userspace

## Conventional Commits

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification to standardize commit messages.

### Setup

Before making commits, configure the validation hooks:

```bash
./scripts/setup-hooks.sh
```

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

### Allowed Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes only
- **style**: Changes that don't affect the meaning of the code (formatting, etc.)
- **refactor**: Code refactoring that neither adds functionality nor fixes bugs
- **perf**: Changes that improve performance
- **test**: Adding tests or correcting existing tests
- **build**: Changes that affect the build system or dependencies
- **ci**: Changes to CI configuration
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Examples

```bash
# Features
feat(userspace): add ARM64 cross-compilation support
feat(build): add parallel compilation optimization

# Fixes
fix(scripts): resolve path resolution in setup.sh
fix(build): handle missing dependencies gracefully

# Documentation
docs(readme): update installation instructions
docs: add architecture documentation

# Breaking Changes
feat!: remove support for legacy build system
feat(api)!: change configuration file format

BREAKING CHANGE: The configuration format has changed from JSON to YAML.
```

### Helper Scripts

#### Assisted Commit

Use the `commit.sh` script to make commits easily:

```bash
# Format: ./scripts/commit.sh <type> [scope] <description>
./scripts/commit.sh feat userspace "add ARM64 support"
./scripts/commit.sh fix build "resolve dependency issue"
./scripts/commit.sh docs "update README"
./scripts/commit.sh chore "update dependencies"
```

#### Manual Commit

Or use git directly (will be automatically validated):

```bash
git commit -m "feat(userspace): add new feature"
```

### Automatic Validation

The `commit-msg` hook automatically validates:

1. ✅ **Format**: Must follow `<type>[scope]: <description>`
2. ✅ **Valid types**: Only recognized types
3. ✅ **Length**: Maximum 100 characters on first line
4. ✅ **Style**: Lowercase description, no period at end
5. ✅ **Breaking changes**: Correct format with `!`

### Commits That Will Be Rejected

```bash
❌ "Add new feature"                    # No type
❌ "feat: Add new feature"              # Uppercase description
❌ "feat: add new feature."             # Period at end
❌ "feature: add new feature"           # Invalid type
❌ "feat(userspace): this is way too long description that exceeds maximum"
```

### Commit Template

When using `git commit` (without `-m`), an editor will open with a template that includes:

- Format explanation
- List of valid types
- Practical examples
- Guidelines for breaking changes

### Additional Tools

The project includes configuration for [Commitizen](https://commitizen-tools.github.io/commitizen/):

```bash
# Install commitizen (optional)
pip install commitizen

# Make interactive commit
cz commit

# Generate automatic changelog
cz changelog
```