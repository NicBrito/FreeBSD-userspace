#!/usr/bin/env bash
#
# setup-hooks.sh - Configure Git hooks for Conventional Commits
#

set -euo pipefail

# Color codes
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

msg() {
    echo -e "${BLUE}==>${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

main() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local project_dir="$(dirname "$script_dir")"

    cd "$project_dir"

    msg "Configuring Git hooks for Conventional Commits..."

    # Configure custom hooks directory
    if ! git config core.hooksPath .githooks 2>/dev/null; then
        git config core.hooksPath .githooks
        success "Hooks directory configured: .githooks"
    else
        success "Hooks directory already configured"
    fi

    # Configure commit message template
    if ! git config commit.template .gitmessage 2>/dev/null; then
        git config commit.template .gitmessage
        success "Commit message template configured"
    else
        success "Commit message template already configured"
    fi

    # Check if hook is executable
    if [[ -x .githooks/commit-msg ]]; then
        success "Hook commit-msg is executable"
    else
        chmod +x .githooks/commit-msg
        success "Hook commit-msg made executable"
    fi

    echo ""
    msg "Configuration completed!"
    echo ""
    echo -e "${YELLOW}How to use:${NC}"
    echo "  1. Use 'git commit' (without -m) to open editor with template"
    echo "  2. Or use: git commit -m \"feat(scope): lowercase description\""
    echo "  3. The hook will automatically validate the commit format"
    echo ""
    echo -e "${YELLOW}Valid formats:${NC}"
    echo "  feat(userspace): add new cross-compilation feature"
    echo "  fix(build): resolve dependency issue"
    echo "  docs: update README with new instructions"
    echo "  chore: update dependencies"
    echo ""
    echo -e "${YELLOW}To test:${NC}"
    echo "  git commit -m \"test: invalid format\" # Will be rejected"
    echo "  git commit -m \"feat: add valid feature\" # Will be accepted"
}

main "$@"