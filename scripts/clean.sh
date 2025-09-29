#!/usr/bin/env bash
#
# clean.sh - Build and artifacts cleanup
#

set -euo pipefail

# --- Color Definitions ---
readonly C_RESET='\033[0m'
readonly C_INFO='\033[0;34m'
readonly C_SUCCESS='\033[0;32m'
readonly C_WARN='\033[0;33m'

msg() {
    printf "${C_INFO}==>${C_RESET} %s\n" "$1"
}

success() {
    printf "${C_SUCCESS}✅ %s${C_RESET}\n" "$1"
}

warn() {
    printf "${C_WARN}⚠️  %s${C_RESET}\n" "$1"
}

# --- Global Variables ---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"

main() {
    local clean_type="${1:-partial}"

    case "$clean_type" in
        "partial"|"p")
            clean_partial
            ;;
        "full"|"f")
            clean_full
            ;;
        "dist"|"d")
            clean_dist
            ;;
        *)
            show_usage
            ;;
    esac
}

show_usage() {
    echo "Usage: $0 [cleanup_type]"
    echo ""
    echo "Cleanup types:"
    echo "  partial, p    - Clean build objects (default)"
    echo "  full, f       - Clean everything (objects + distribution)"
    echo "  dist, d       - Clean only distribution"
    echo ""
    echo "Examples:"
    echo "  $0              # Partial cleanup"
    echo "  $0 full         # Complete cleanup"
    echo "  $0 dist         # Clean only dist/"
}

clean_partial() {
    msg "Performing partial cleanup (build objects)..."

    cd "${PROJECT_DIR}"

    # Clean build objects
    if [ -d "obj" ]; then
        msg "Removing obj/ directory..."
        rm -rf obj/
        success "obj/ directory removed"
    else
        warn "obj/ directory not found"
    fi

    # Clean temporary files
    msg "Removing temporary files..."
    find . -name "*.tmp" -delete 2>/dev/null || true
    find . -name "*.log" -delete 2>/dev/null || true

    success "Partial cleanup completed"
}

clean_full() {
    msg "Performing complete cleanup (objects + distribution)..."

    cd "${PROJECT_DIR}"

    # Clean objects
    if [ -d "obj" ]; then
        msg "Removing obj/ directory..."
        rm -rf obj/
    fi

    # Clean distribution
    if [ -d "dist" ]; then
        msg "Removing dist/ directory..."
        rm -rf dist/
    fi

    # Clean temporary files
    msg "Removing temporary files..."
    find . -name "*.tmp" -delete 2>/dev/null || true
    find . -name "*.log" -delete 2>/dev/null || true
    find . -name ".DS_Store" -delete 2>/dev/null || true

    # Clean FreeBSD cache (if exists)
    if [ -d "freebsd-src" ]; then
        cd freebsd-src
        if command -v gmake &> /dev/null; then
            msg "Running cleanup on FreeBSD source code..."
            gmake cleandir 2>/dev/null || warn "FreeBSD cleanup failed (normal if never compiled)"
        fi
        cd ..
    fi

    success "Complete cleanup completed"
}

clean_dist() {
    msg "Performing distribution cleanup..."

    cd "${PROJECT_DIR}"

    if [ -d "dist" ]; then
        msg "Removing dist/ directory..."
        rm -rf dist/
        success "dist/ directory removed"
    else
        warn "dist/ directory not found"
    fi

    success "Distribution cleanup completed"
}

main "$@"
