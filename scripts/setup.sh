#!/usr/bin/env bash
#
# setup.sh - Initial FreeBSD-userspace environment setup
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
    printf "${C_ERROR}[ERROR] %s${C_RESET}\n" "$1" >&2
    exit 1
}

# --- Global Variables ---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"

main() {
    msg "Setting up FreeBSD-userspace environment..."

    # Check operating system
    case "$(uname)" in
        Darwin)
            setup_macos
            ;;
        Linux)
            setup_linux
            ;;
        FreeBSD)
            setup_freebsd
            ;;
        *)
            error "Unsupported operating system: $(uname)"
            ;;
    esac

    # Initialize/update submodule
    setup_submodule

    # Create necessary directories
    setup_directories

    # Check dependencies
    verify_dependencies

    success "Initial setup completed!"
    echo ""
    echo "Next steps:"
    echo "  1. Run './build.sh aarch64' for ARM64 build"
    echo "  2. Run './build.sh amd64' for x86_64 build"
}

setup_macos() {
    msg "Detected macOS - setting up dependencies..."

    if ! command -v brew &> /dev/null; then
        error "Homebrew not found. Install at: https://brew.sh"
    fi

    # Install necessary dependencies
    msg "Installing dependencies via Homebrew..."
    brew install gmake git || warn "Failed to install some dependencies (they may already be installed)"

    success "macOS dependencies configured"
}

setup_linux() {
    msg "Detected Linux - checking dependencies..."

    # Detect distribution
    if command -v apt-get &> /dev/null; then
        msg "Debian-based distribution detected"
        echo "Run: sudo apt-get install build-essential git"
    elif command -v yum &> /dev/null; then
        msg "RedHat-based distribution detected"
        echo "Run: sudo yum groupinstall 'Development Tools' && sudo yum install git"
    elif command -v pacman &> /dev/null; then
        msg "Arch Linux detected"
        echo "Run: sudo pacman -S base-devel git"
    else
        warn "Unrecognized Linux distribution - install manually:"
        echo "  - GNU Make"
        echo "  - GCC/Clang"
        echo "  - Git"
    fi
}

setup_freebsd() {
    msg "Detected FreeBSD - checking dependencies..."
    echo "Run: sudo pkg install git"
}

setup_submodule() {
    msg "Configuring FreeBSD submodule..."

    cd "${PROJECT_DIR}"

    # Check if .gitmodules already exists
    if [ ! -f ".gitmodules" ]; then
        msg "Adding FreeBSD repository as submodule..."
        git submodule add https://github.com/freebsd/freebsd-src.git freebsd-src
    fi

    # Initialize and update submodules
    msg "Initializing and updating submodules..."
    git submodule update --init --recursive

    success "FreeBSD submodule configured"
}

setup_directories() {
    msg "Creating directory structure..."

    cd "${PROJECT_DIR}"

    # Create necessary directories
    mkdir -p obj dist configs docs

    # Create .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << 'EOF'
# Build artifacts
obj/
dist/

# Temporary files
*.tmp
*.log

# macOS
.DS_Store

# IDE
.vscode/
.idea/
EOF
    fi

    success "Directory structure created"
}

verify_dependencies() {
    msg "Checking dependencies..."

    local missing_deps=()

    # Check GNU Make
    if ! command -v gmake &> /dev/null && ! command -v make &> /dev/null; then
        missing_deps+=("GNU Make (gmake)")
    fi

    # Check Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("Git")
    fi

    # Check compiler
    if ! command -v gcc &> /dev/null && ! command -v clang &> /dev/null; then
        missing_deps+=("C compiler (gcc or clang)")
    fi

    if [ ${#missing_deps[@]} -eq 0 ]; then
        success "All dependencies are installed"
    else
        error "Missing dependencies: ${missing_deps[*]}"
    fi
}

main "$@"
