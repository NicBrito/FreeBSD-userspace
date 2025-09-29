#!/usr/bin/env bash
#
# build.sh - Cross-compiles the FreeBSD userspace on macOS.
#
# This script is aligned with FreeBSD's official build best practices,
# including out-of-source object directories to ensure a clean build.

# --- Script Configuration and Strict Mode ---

set -euo pipefail

# --- Helper Functions and Color Definitions ---

readonly C_RESET='\033[0m'
readonly C_INFO='\033[0;34m'
readonly C_SUCCESS='\033[0;32m'
readonly C_ERROR='\033[0;31m'

msg() {
    printf "${C_INFO}==>${C_RESET} %s\n" "$1"
}

success() {
    printf "${C_SUCCESS}✅ %s${C_RESET}\n" "$1"
}

error() {
    printf "${C_ERROR}[ERROR] %s${C_RESET}\n" "$1" >&2
    exit 1
}

# --- Global Variables ---

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SRC_DIR="${SCRIPT_DIR}/freebsd-src"
readonly DEST_DIR="${SCRIPT_DIR}/dist"
readonly OBJ_DIR_PREFIX="${SCRIPT_DIR}/obj" # Directory for intermediate build files
readonly NUM_JOBS=$(sysctl -n hw.ncpu)

# --- Main Execution Logic ---

main() {
    # --- CRITICAL ENVIRONMENT FIXES (as per official FreeBSD guidelines) ---

    # 1. Set the object directory prefix to build outside the source tree.
    #    This is the most critical fix for preventing build state corruption.
    export MAKEOBJDIRPREFIX="${OBJ_DIR_PREFIX}"

    # 2. Use system make (BSD make is preferred for FreeBSD)
    # GNU make may cause compatibility issues with FreeBSD's build system

    # 4. Unset host compiler variables to prevent interference.
    unset CC CXX

    # --- SCRIPT EXECUTION ---

    local target_arch="${1:-arm64}"
    local target_arch_param="$target_arch"

    # Convert common arch names to FreeBSD names
    case "$target_arch" in
        "aarch64"|"arm64")
            target_arch="arm64"
            target_arch_param="aarch64"
            ;;
        "amd64"|"x86_64"|"x64")
            target_arch="amd64"
            target_arch_param="amd64"
            ;;
        *)
            error "Invalid architecture specified: '$target_arch'. Please use 'arm64' (or 'aarch64') or 'amd64' (or 'x86_64')."
            ;;
    esac

    msg "Initializing FreeBSD userspace cross-compilation on macOS"
    echo "    - Source Directory:      ${SRC_DIR}"
    echo "    - Destination Directory: ${DEST_DIR}"
    echo "    - Object Directory:      ${OBJ_DIR_PREFIX}"
    echo "    - Target Architecture:   ${target_arch}"
    echo "    - Parallel Jobs:         ${NUM_JOBS}"
    echo ""

    # Use BSD make (bmake) which is required for FreeBSD builds
    local make_cmd="bmake"

    if ! command -v bmake &> /dev/null; then
        error "BSD make (bmake) not found. Install it with: brew install bmake"
    fi

    msg "Using BSD make: $(which bmake)"

    if [ ! -d "${SRC_DIR}" ]; then
        error "FreeBSD source directory not found at: ${SRC_DIR}\n        Please ensure the git submodule is initialized."
    fi

    # Create the object and distribution directories
    mkdir -p "${OBJ_DIR_PREFIX}" "${DEST_DIR}"

    cd "${SRC_DIR}"

    # Check if configuration files exist and use them
    local srcconf_arg=""

    # Temporarily disable custom src.conf to debug the issue
    # if [ -f "${SCRIPT_DIR}/configs/src.conf.minimal" ]; then
    #     srcconf_arg="SRCCONF=${SCRIPT_DIR}/configs/src.conf.minimal"
    #     msg "Using minimal configuration: configs/src.conf.minimal"
    # fi

    msg "[1/2] Cross-compiling the userspace (buildworld) for ${target_arch}. This will take a significant amount of time."
    ${make_cmd} -j"${NUM_JOBS}" TARGET=${target_arch} TARGET_ARCH=${target_arch_param} ${srcconf_arg} buildworld

    msg "[2/2] Installing userspace to destination directory (installworld)."
    ${make_cmd} TARGET=${target_arch} TARGET_ARCH=${target_arch_param} ${srcconf_arg} installworld DESTDIR="${DEST_DIR}"

    echo ""
    success "FreeBSD (${target_arch}) userspace has been built and extracted to:"
    success "   ${DEST_DIR}"
}

# --- Script Entrypoint ---

main "$@"