# 🏗️ Architecture Guide - FreeBSD-userspace

> **Technical deep dive** into the project structure, build flow, and design decisions

---

## 🎯 Overview

FreeBSD-userspace is architected with **modularity**, **cleanliness**, and **FreeBSD best practices** at its core. The design enables reproducible, cross-platform builds while maintaining the integrity of the official FreeBSD codebase.

## 📁 Project Structure

### 🗂️ Root Level
```
FreeBSD-userspace/
├── 📄 README.md           # Main documentation
├── 🔧 build.sh            # Primary build orchestrator
├── 📋 pyproject.toml      # Project configuration & commitizen
├── 🤝 CONTRIBUTING.md     # Contribution guidelines
├── 🙈 .gitignore          # Git exclusions
└── 🔗 .gitmodules         # Submodule configuration
```

### 🛠️ Automation (`scripts/`)
Essential automation toolkit:

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup.sh` | Environment initialization | `./scripts/setup.sh` |
| `clean.sh` | Build artifacts cleanup | `./scripts/clean.sh` |
| `validate.sh` | Build result verification | `./scripts/validate.sh` |
| `setup-hooks.sh` | Git hooks configuration | `./scripts/setup-hooks.sh` |
| `commit.sh` | Assisted commit creation | `./scripts/commit.sh feat "description"` |

### 🔗 Source Code (`freebsd-src/`)
**Official FreeBSD Repository Integration**

- **Type**: Git submodule
- **Origin**: [freebsd/freebsd-src](https://github.com/freebsd/freebsd-src)
- **Advantages**:
  - ✅ Always synchronized with official repository
  - ✅ Simplified updates and version tracking
  - ✅ Complete build history preservation
  - ✅ Zero modifications to upstream code

### ⚙️ Configuration (`configs/`)
Build optimization files:

| File | Purpose | Impact |
|------|---------|--------|
| `src.conf.minimal` | Component reduction | Smaller builds, faster compilation |
| `make.conf.cross` | Cross-compilation settings | Multi-architecture support |

### 🏗️ Build Artifacts
| Directory | Content | Lifecycle |
|-----------|---------|-----------|
| `obj/` | Intermediate compilation objects | Auto-generated, cleanable |
| `dist/` | Final extracted userspace | Auto-generated, deployable |

### 📚 Documentation (`docs/`)
Technical documentation and guides.

## 🔄 Build Flow

### 🚀 Phase 1: Initialization
```bash
./scripts/setup.sh
```

**Actions performed**:
- 🔍 **OS Detection**: Identifies host platform (macOS/Linux)
- 📦 **Dependency Installation**: Installs required build tools
- 🔗 **Submodule Setup**: Initializes and updates FreeBSD source
- 📁 **Directory Creation**: Prepares build workspace

### ⚙️ Phase 2: Compilation
```bash
./build.sh [architecture]
```

**Build process**:
1. **Environment Setup**
   - Sets `MAKEOBJDIRPREFIX` for out-of-source builds
   - Configures cross-compilation variables
   - Validates BSD make availability

2. **World Build** (`buildworld`)
   - Compiles entire FreeBSD userspace
   - Uses parallel jobs for optimization
   - Applies minimal configuration if available

3. **World Install** (`installworld`)
   - Installs userspace to destination directory
   - Maintains proper file permissions and structure

### ✅ Phase 3: Validation
```bash
./scripts/validate.sh
```

**Verification steps**:
- 🔍 **Structure Validation**: Confirms userspace directory layout
- 🔬 **Binary Testing**: Validates essential executable functionality
- 🧪 **Integrity Checks**: Ensures build completeness and consistency

## 📦 Userspace Components

### 🔧 Core Binaries
| Directory | Purpose | Key Examples |
|-----------|---------|--------------|
| `bin/` | Essential commands | `ls`, `cp`, `mv`, `cat`, `sh`, `chmod` |
| `sbin/` | System administration | `mount`, `umount`, `fsck`, `newfs` |

### 👤 User Tools
| Directory | Purpose | Key Examples |
|-----------|---------|--------------|
| `usr/bin/` | User utilities | `grep`, `awk`, `sed`, `tar`, `gzip` |
| `usr/sbin/` | Advanced admin tools | `cron`, `syslogd`, `ntpd` |

### 📚 Libraries & Headers
| Directory | Purpose | Contents |
|-----------|---------|----------|
| `lib/`, `usr/lib/` | Runtime libraries | `libc`, `libm`, shared objects |
| `usr/include/` | Development headers | System APIs, data structures |

### 📄 Shared Resources
| Directory | Purpose | Contents |
|-----------|---------|----------|
| `usr/share/` | Common data | Manual pages, locales, timezones, templates |

## 🚀 Optimization Strategies

### 1. 🏗️ Out-of-Source Builds
- **Separation**: Compiled objects in `obj/` separate from source code
- **Benefits**: Clean builds, easy cleanup, parallel development
- **Implementation**: `MAKEOBJDIRPREFIX` environment variable

### 2. 📦 Minimal Configurations
- **Purpose**: Remove unnecessary components (kernel, docs, legacy tools)
- **Impact**:
  - ⏱️ **Faster compilation** (reduced build time)
  - 💾 **Smaller footprint** (reduced storage requirements)
  - 🎯 **Focused output** (only essential userspace)

### 3. 🔀 Cross-Compilation Support
- **Multi-Architecture**: Native ARM64 and x86_64 support
- **Host Independence**: Build on macOS/Linux for any target
- **Optimization**: Platform-specific compiler flags and settings

### 4. ⚡ Parallel Processing
- **Auto-Detection**: Uses all available CPU cores (`sysctl -n hw.ncpu`)
- **Make Jobs**: Parallel compilation with `-j${NUM_JOBS}`
- **Efficiency**: Dramatically reduces build time on multi-core systems

## 🎯 Best Practices

### 📏 Versioning & Release Management
| Practice | Implementation | Benefit |
|----------|---------------|---------|
| **Semantic Versioning** | Git tags (`v1.0.0`) | Clear version tracking |
| **Submodule Sync** | Regular FreeBSD updates | Security & feature updates |
| **Changelog** | Automated via commitizen | Transparent change tracking |

### 🧪 Testing & Validation
| Level | Method | Coverage |
|-------|--------|----------|
| **Build Testing** | Multiple architectures | Cross-platform compatibility |
| **Binary Validation** | Essential command testing | Functional verification |
| **Integration Testing** | Full userspace validation | End-to-end functionality |

### 🧹 Maintenance & Hygiene
| Task | Frequency | Command |
|------|-----------|---------|
| **Cleanup** | After builds | `./scripts/clean.sh` |
| **Updates** | Monthly | `git submodule update --remote` |
| **Disk Monitoring** | Regular | `du -sh obj/ dist/` |

## 🔧 Extensibility

### 🏛️ Adding New Architectures

1. **Update Build Script**
   ```bash
   # Edit build.sh - add new architecture case
   case "$target_arch" in
       "riscv64")
           target_arch="riscv64"
           target_arch_param="riscv64"
           ;;
   ```

2. **Architecture-Specific Configuration**
   - Create `configs/make.conf.riscv64` if needed
   - Add any special build flags or requirements

3. **Testing & Validation**
   - Test build process thoroughly
   - Update validation scripts if necessary
   - Document any architecture-specific requirements

### ⚙️ Customizing Components

1. **Modify Minimal Configuration**
   ```bash
   # Edit configs/src.conf.minimal
   WITHOUT_GAMES=YES           # Remove games
   WITHOUT_EXAMPLES=YES        # Remove examples
   WITHOUT_DOCS=YES            # Remove documentation
   ```

2. **Cross-Compilation Flags**
   ```bash
   # Edit configs/make.conf.cross
   CFLAGS+=-O2 -pipe           # Optimization flags
   CXXFLAGS+=-O2 -pipe         # C++ optimization
   ```

3. **Document Changes**
   - Update relevant documentation
   - Add configuration rationale
   - Include performance impact notes

### 🚀 CI/CD Integration

1. **Automated Builds**
   ```yaml
   # Example GitHub Actions workflow
   - name: Build ARM64 Userspace
     run: ./build.sh arm64

   - name: Build x86_64 Userspace
     run: ./build.sh amd64
   ```

2. **Validation Pipeline**
   ```bash
   # Automated validation
   ./scripts/validate.sh build
   ./scripts/validate.sh integrity
   ```

3. **Multi-Architecture Matrix**
   - Parallel builds for all supported architectures
   - Automated testing and validation
   - Artifact collection and distribution

---

## 🔗 Related Documentation

- 📖 **[Main README](../README.md)** - Project overview and quick start
- 🤝 **[Contributing Guide](../CONTRIBUTING.md)** - Development workflow and standards
- 🔧 **[Build Script](../build.sh)** - Main build orchestrator
- ⚙️ **[Setup Script](../scripts/setup.sh)** - Environment initialization

> 💡 **Need help?** Check the [official FreeBSD build documentation](https://docs.freebsd.org/en/books/handbook/cutting-edge/) for advanced build system details.
