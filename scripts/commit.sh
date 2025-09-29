#!/usr/bin/env bash
#
# commit.sh - Helper script for conventional commits
#

set -euo pipefail

# Color codes
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

show_help() {
    echo "Usage: $0 <type> [scope] <description>"
    echo ""
    echo "Valid types:"
    echo "  feat     - New feature"
    echo "  fix      - Bug fix"
    echo "  docs     - Documentation changes"
    echo "  style    - Formatting changes"
    echo "  refactor - Code refactoring"
    echo "  perf     - Performance improvement"
    echo "  test     - Adding or fixing tests"
    echo "  build    - Changes to build system"
    echo "  ci       - Changes to CI configuration"
    echo "  chore    - Other changes (maintenance)"
    echo "  revert   - Revert previous commit"
    echo ""
    echo "Examples:"
    echo "  $0 feat userspace \"add ARM64 support\""
    echo "  $0 fix build \"resolve dependency issue\""
    echo "  $0 docs \"update README\""
    echo "  $0 chore \"update dependencies\""
    echo ""
    echo "For breaking changes, add '!' after type:"
    echo "  $0 feat! api \"change authentication method\""
}

validate_type() {
    local type="$1"
    local valid_types=("feat" "fix" "docs" "style" "refactor" "perf" "test" "build" "ci" "chore" "revert")

    # Remove '!' if present for validation
    local clean_type="${type%!}"

    for valid_type in "${valid_types[@]}"; do
        if [[ "$clean_type" == "$valid_type" ]]; then
            return 0
        fi
    done
    return 1
}

main() {
    if [[ $# -lt 2 ]]; then
        show_help
        exit 1
    fi

    local type="$1"
    local scope=""
    local description=""

    if [[ $# -eq 2 ]]; then
        description="$2"
    elif [[ $# -eq 3 ]]; then
        scope="$2"
        description="$3"
    else
        echo -e "${RED}Error: Too many arguments${NC}" >&2
        show_help
        exit 1
    fi

    # Validate type
    if ! validate_type "$type"; then
        echo -e "${RED}Error: Invalid type '$type'${NC}" >&2
        show_help
        exit 1
    fi

    # Build commit message
    local commit_msg="$type"
    if [[ -n "$scope" ]]; then
        commit_msg="${commit_msg}(${scope})"
    fi
    commit_msg="${commit_msg}: ${description}"

    echo -e "${BLUE}Commit message:${NC} $commit_msg"
    echo -n "Confirm commit? [y/N] "
    read -r confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git commit -m "$commit_msg"
        echo -e "${GREEN}✅ Commit completed successfully!${NC}"
    else
        echo -e "${YELLOW}Commit cancelled${NC}"
    fi
}

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

main "$@"