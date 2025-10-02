# 🔧 FreeBSD Userspace

> **Extract and compile the complete FreeBSD userspace without the kernel**

A lightweight, cross-platform build system that extracts all FreeBSD user components (binaries, libraries, utilities) from the official repository, perfect for containerization, embedded systems, or educational purposes.

---

## ✨ Features

- 🚀 **Cross-compilation support** for ARM64 and x86_64
- 📦 **Minimal configuration** - only what you need
- 🔄 **Automated build process** with validation
- 📋 **Conventional Commits** with automated hooks
- 🧹 **Clean builds** using out-of-source compilation

## FreeBSD Userspace Components

The FreeBSD userspace includes:

- **bin/**: Basic system commands (`ls`, `cp`, `mv`, `cat`, etc.)
- **sbin/**: System administration commands
- **usr/bin/**: User utilities
- **usr/sbin/**: Administration utilities
- **lib/**: System libraries
- **libexec/**: Auxiliary executables
- **share/**: Shared data (man pages, locales, etc.)
- **include/**: System headers
- **etc/**: Configuration files

## 🚀 Quick Start

### Prerequisites

| Platform | Requirements |
|----------|-------------|
| **macOS** | `brew install make git` |
| **Linux** | `sudo apt-get install build-essential git` |

### Build Process

```bash
# 1. Clone with submodules
git clone --recursive https://github.com/NicBrito/FreeBSD-userspace.git
cd FreeBSD-userspace

# 2. Initial setup (optional)
./scripts/setup.sh

# 3. Build for your target architecture
./build.sh arm64    # For ARM64/Apple Silicon
./build.sh amd64    # For x86_64/Intel
```

> 💡 **Result**: Complete userspace available in `dist/` directory

## 📦 What's Included

The FreeBSD userspace contains all essential user-level components:

| Component | Description | Examples |
|-----------|-------------|----------|
| `bin/` | Core system commands | `ls`, `cp`, `mv`, `cat`, `sh` |
| `sbin/` | System administration | `mount`, `umount`, `fsck` |
| `usr/bin/` | User utilities | `grep`, `awk`, `sed`, `tar` |
| `usr/sbin/` | Admin utilities | `cron`, `syslogd` |
| `lib/` | System libraries | `libc`, `libm`, shared libraries |
| `usr/include/` | Development headers | System APIs, structures |
| `usr/share/` | Shared resources | Man pages, locales, timezones |

## 🏗️ Architecture

```
FreeBSD-userspace/
├── 🔧 build.sh              # Main build script
├── 📜 scripts/              # Automation toolkit
│   ├── setup.sh             # Environment setup
│   ├── clean.sh             # Build cleanup
│   └── validate.sh          # Result validation
├── 🔗 freebsd-src/          # Official FreeBSD (submodule)
├── ⚙️  configs/             # Build configurations
├── 📁 obj/                  # Build artifacts (auto-generated)
└── 📦 dist/                 # Final userspace (auto-generated)
```

> 📚 **Detailed documentation**: [`docs/architecture.md`](docs/architecture.md)

## Result

After a successful build, the complete userspace will be available in `dist/`, ready to be used or packaged.

## Make Targets Used

- `buildworld`: Compiles the entire userspace
- `installworld`: Installs userspace to destination directory

## Custom Configurations

The project includes optimized configurations in `configs/`:
- `src.conf.minimal`: Minimal configuration to reduce components
- `make.conf.cross`: Configuration for cross-compilation

## 🛠️ Development

### Conventional Commits

This project follows [Conventional Commits](https://www.conventionalcommits.org/) for clean git history:

```bash
# Setup automatic validation
./scripts/setup-hooks.sh

# Commit examples
git commit -m "feat(build): add ARM64 optimization"
git commit -m "fix(script): resolve path resolution issue"
git commit -m "docs: update installation guide"
```

**Supported types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

> 📋 **Complete guide**: [`CONTRIBUTING.md`](CONTRIBUTING.md)

---

## 📄 License

This project follows the same **BSD license** as the original FreeBSD project.
