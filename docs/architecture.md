# Architecture Guide - FreeBSD-userspace

## Architecture Overview

The FreeBSD-userspace project was designed with a modular and clean architecture, following FreeBSD build best practices and software development standards.

## Directory Structure

### Root Directory
```
FreeBSD-userspace/
├── README.md              # Main documentation
├── build.sh               # Main build script
├── .gitignore            # Git ignored files
└── .gitmodules           # Submodule configuration
```

### Scripts (`scripts/`)
Auxiliary scripts for automation:
- `setup.sh`: Initial environment setup
- `clean.sh`: Build and artifacts cleanup
- `validate.sh`: Environment and results validation

### Source Code (`freebsd-src/`)
Official FreeBSD repository submodule:
- **Origin**: https://github.com/freebsd/freebsd-src
- **Type**: Git submodule
- **Advantages**:
  - Always synchronized with official repository
  - Facilitates updates
  - Maintains complete history

### Configurations (`configs/`)
Optimized configuration files:
- `src.conf.minimal`: Minimal configuration to reduce components
- `make.conf.cross`: Configuration for cross-compilation

### Build Artifacts
- `obj/`: Intermediate compilation objects (generated automatically)
- `dist/`: Extracted userspace - final result (generated automatically)

### Documentation (`docs/`)
Detailed technical documentation of the project.

## Build Flow

### 1. Initialization
```bash
./scripts/setup.sh
```
- Detects operating system
- Installs necessary dependencies
- Configures submodules
- Creates directory structure

### 2. Compilation
```bash
./build.sh [architecture]
```
- Defines environment variables
- Executes `buildworld` (compiles userspace)
- Executes `installworld` (installs to destination)

### 3. Validation
```bash
./scripts/validate.sh build
```
- Verifies userspace structure
- Validates essential binaries
- Confirms result integrity

## Userspace Components

### Essential Binaries (`bin/`, `sbin/`)
- **bin/**: Basic commands (`ls`, `cp`, `mv`, `cat`, `sh`, etc.)
- **sbin/**: Administration commands (`mount`, `umount`, `fsck`, etc.)

### User Utilities (`usr/bin/`, `usr/sbin/`)
- **usr/bin/**: Advanced tools (`grep`, `awk`, `sed`, `tar`, etc.)
- **usr/sbin/**: System utilities (`cron`, `syslogd`, etc.)

### Libraries (`lib/`, `usr/lib/`)
- System libraries (libc, libm, etc.)
- Shared libraries
- Development files

### Shared Resources (`usr/share/`)
- Manual pages
- Localization data
- Timezones
- Configuration templates

### Headers (`usr/include/`)
- System headers
- Public APIs
- Structure definitions

## Optimization Strategies

### 1. Out-of-Source Build
- Compiled objects in separate `obj/` from source code
- Enables clean and parallel builds
- Facilitates cleanup and maintenance

### 2. Minimal Configurations
- Removes unnecessary components (kernel, boot, docs)
- Reduces compilation time
- Decreases final userspace size

### 3. Cross-Compilation
- Native support for multiple architectures
- Platform-specific optimizations
- Compatibility with different host systems

### 4. Parallelization
- Parallel builds using multiple cores
- Automatic system capacity detection
- Compilation flag optimization

## Best Practices

### 1. Versioning
- Use Git tags for stable versions
- Keep submodule synchronized
- Document significant changes

### 2. Testing
- Always run validation after builds
- Test on different architectures
- Verify binary integrity

### 3. Maintenance
- Clean old builds regularly
- Update submodules periodically
- Monitor disk space

## Extensibility

### Adding New Architectures
1. Add support in `build.sh`
2. Create specific configurations in `configs/`
3. Test and validate the result

### Customizing Components
1. Modify `configs/src.conf.minimal`
2. Adjust flags in `configs/make.conf.cross`
3. Document the changes

### Integrating with CI/CD
1. Use automated scripts
2. Implement automatic validation
3. Configure parallel builds per architecture
