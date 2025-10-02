# 🤝 Contributing to FreeBSD-userspace

> **Welcome!** This guide will help you contribute effectively to the project using our standardized workflow.

---

## 📋 Conventional Commits

We follow [Conventional Commits](https://www.conventionalcommits.org/) to maintain a clean, readable git history that enables automated changelog generation.

### 🔧 Quick Setup

```bash
# Enable automatic commit validation
./scripts/setup-hooks.sh
```

### 📝 Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

### 🏷️ Commit Types

| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New features | `feat(build): add parallel compilation` |
| `fix` | Bug fixes | `fix(script): resolve path resolution` |
| `docs` | Documentation | `docs: update installation guide` |
| `style` | Code formatting | `style: fix indentation` |
| `refactor` | Code restructuring | `refactor(build): simplify script logic` |
| `perf` | Performance improvements | `perf: optimize memory usage` |
| `test` | Testing | `test: add build validation tests` |
| `build` | Build system | `build: update dependencies` |
| `ci` | CI/CD changes | `ci: add automated testing` |
| `chore` | Maintenance | `chore: update gitignore` |
| `revert` | Revert changes | `revert: undo feature X` |

## 🚀 Making Commits

### Option 1: Assisted Commit (Recommended)

```bash
# Format: ./scripts/commit.sh <type> [scope] <description>
./scripts/commit.sh feat build "add ARM64 optimization"
./scripts/commit.sh fix script "resolve dependency issue"
./scripts/commit.sh docs "update README structure"
```

### Option 2: Manual Commit

```bash
# Direct git commit (automatically validated)
git commit -m "feat(userspace): add new component extraction"
```

### Option 3: Interactive Mode

```bash
# Install commitizen for interactive prompts
pip install commitizen
cz commit
```

## ✅ Validation Rules

Our commit hook validates:

| Rule | Description | Example |
|------|-------------|---------|
| **Format** | Must follow conventional format | ✅ `feat: add feature` |
| **Type** | Must use valid commit types | ❌ `feature: add feature` |
| **Length** | Max 100 characters on first line | ❌ Long descriptions |
| **Style** | Lowercase, no ending period | ❌ `feat: Add feature.` |
| **Breaking** | Proper format for breaking changes | ✅ `feat!: breaking change` |

### ❌ Common Mistakes

```bash
❌ "Add new feature"              # Missing type
❌ "feat: Add new feature"        # Uppercase description
❌ "feat: add new feature."       # Period at end
❌ "feature: add new feature"     # Invalid type
❌ "feat: this description is way too long and exceeds the maximum allowed length"
```

## 🔧 Breaking Changes

For commits that introduce breaking changes:

```bash
# Method 1: Use ! after type
feat!: remove legacy build system support

# Method 2: Add footer
feat(api): change configuration format

BREAKING CHANGE: Configuration format changed from JSON to YAML.
```

## 🎯 Commit Template

When using `git commit` without `-m`, an editor opens with a helpful template including:
- Format explanation and examples
- List of valid types
- Guidelines for breaking changes

## 📊 Additional Tools

### Changelog Generation
```bash
# Generate automatic changelog (requires commitizen)
cz changelog
```

### Version Bumping
```bash
# Automatically bump version based on commits
cz bump
```

---

> 💡 **Tip**: The project uses [commitizen](https://commitizen-tools.github.io/commitizen/) configuration in `pyproject.toml` for advanced features.