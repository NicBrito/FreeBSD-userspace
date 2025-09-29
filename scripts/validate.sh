#!/usr/bin/env bash
#
# validate.sh - Environment and build result validation
#

set -euo pipefail

# --- Color Definitions ---
readonly C_RESET='\033[0m'
readonly C_INFO='\033[0;34m'
readonly C_SUCCESS='\033[0;32m'
readonly C_ERROR='\033[0;31m'
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

error() {
    printf "${C_ERROR}❌ %s${C_RESET}\n" "$1"
}

# --- Global Variables ---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"

main() {
    local validation_type="${1:-environment}"

    case "$validation_type" in
        "environment"|"env"|"e")
            validate_environment
            ;;
        "build"|"b")
            validate_build_result
            ;;
        "all"|"a")
            validate_environment
            echo ""
            validate_build_result
            ;;
        *)
            show_usage
            ;;
    esac
}

show_usage() {
    echo "Usage: $0 [validation_type]"
    echo ""
    echo "Validation types:"
    echo "  environment, env, e  - Validate build environment (default)"
    echo "  build, b            - Validate build result"
    echo "  all, a              - Validate environment and result"
    echo ""
    echo "Examples:"
    echo "  $0                  # Validate environment"
    echo "  $0 build            # Validate build result"
    echo "  $0 all              # Validate everything"
}

validate_environment() {
    msg "Validating build environment..."

    local issues=0

    # Check operating system
    msg "Operating system: $(uname -s) $(uname -r)"

    # Check dependencies
    msg "Checking essential dependencies..."

    # Git
    if command -v git &> /dev/null; then
        success "Git: $(git --version)"
    else
        error "Git not found"
        ((issues++))
    fi

    # Make
    if command -v gmake &> /dev/null; then
        success "GNU Make: $(gmake --version | head -n1)"
    elif command -v make &> /dev/null; then
        local make_version=$(make --version 2>&1 | head -n1)
        if [[ "$make_version" == *"GNU"* ]]; then
            success "GNU Make: $make_version"
        else
            warn "Make found but may not be GNU Make: $make_version"
        fi
    else
        error "GNU Make not found"
        ((issues++))
    fi

    # Compiler
    if command -v gcc &> /dev/null; then
        success "GCC: $(gcc --version | head -n1)"
    elif command -v clang &> /dev/null; then
        success "Clang: $(clang --version | head -n1)"
    else
        error "No C compiler found (gcc or clang)"
        ((issues++))
    fi

    # Check project structure
    msg "Checking project structure..."

    cd "${PROJECT_DIR}"

    # FreeBSD submodule
    if [ -d "freebsd-src" ] && [ -f "freebsd-src/Makefile" ]; then
        success "FreeBSD submodule: OK"
    else
        error "FreeBSD submodule not found or incomplete"
        echo "  Run: git submodule update --init --recursive"
        ((issues++))
    fi

    # Executable scripts
    for script in build.sh scripts/setup.sh scripts/clean.sh scripts/validate.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            success "Script $script: OK"
        else
            warn "Script $script: not found or not executable"
        fi
    done

    # Disk space
    msg "Checking disk space..."
    local available_space=$(df -h . | awk 'NR==2{print $4}')
    success "Available space: $available_space"
    warn "Recommended: at least 10GB free for complete build"

    # Summary
    echo ""
    if [ $issues -eq 0 ]; then
        success "Build environment: VALID"
        echo "Ready to run './build.sh [architecture]'"
    else
        error "Build environment: $issues problem(s) found"
        echo "Fix the issues before proceeding"
        exit 1
    fi
}

validate_build_result() {
    msg "Validating build result..."

    cd "${PROJECT_DIR}"

    if [ ! -d "dist" ]; then
        error "dist/ directory not found"
        echo "Run './build.sh [architecture]' first"
        exit 1
    fi

    local issues=0

    # Check basic userspace structure
    msg "Checking userspace structure..."

    local essential_dirs=("bin" "sbin" "usr/bin" "usr/sbin" "lib" "usr/lib" "etc" "usr/share")

    for dir in "${essential_dirs[@]}"; do
        if [ -d "dist/$dir" ]; then
            success "Directory $dir: OK"
        else
            error "Directory $dir: not found"
            ((issues++))
        fi
    done

    # Check essential binaries
    msg "Checking essential binaries..."

    local essential_bins=("bin/sh" "bin/ls" "bin/cat" "bin/cp" "bin/mv" "sbin/mount")

    for bin in "${essential_bins[@]}"; do
        if [ -f "dist/$bin" ]; then
            success "Binary $bin: OK"
        else
            warn "Binary $bin: not found"
        fi
    done

    # Check libraries
    msg "Checking essential libraries..."

    local lib_count=$(find dist/lib dist/usr/lib -name "*.so*" 2>/dev/null | wc -l)
    if [ "$lib_count" -gt 0 ]; then
        success "Libraries: $lib_count found"
    else
        warn "No shared libraries found"
    fi

    # Check total size
    msg "Checking userspace size..."
    local total_size=$(du -sh dist 2>/dev/null | cut -f1)
    success "Total size: $total_size"

    # Check binary architecture (if possible)
    if command -v file &> /dev/null; then
        msg "Checking binary architecture..."
        local arch_info=$(file dist/bin/ls 2>/dev/null | head -n1)
        if [[ -n "$arch_info" ]]; then
            success "Architecture: $arch_info"
        fi
    fi

    # Summary
    echo ""
    if [ $issues -eq 0 ]; then
        success "Build result: VALID"
        echo "FreeBSD userspace successfully extracted to dist/"
    else
        error "Build result: $issues problem(s) found"
        echo "The build may be incomplete"
        exit 1
    fi
}

main "$@"
