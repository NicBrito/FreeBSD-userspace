# FreeBSD-userspace

Project to extract and compile only the userspace of the FreeBSD operating system, without the kernel.

## Objective

This project uses the official FreeBSD repository to build only the userspace, extracting all user components (binaries, libraries, utilities) without including the system kernel.

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

## Supported Architectures

- `aarch64` (ARM64)
- `amd64` (x86_64)

## Prerequisites

### macOS
```bash
# Install dependencies via Homebrew
brew install gmake git
```

### FreeBSD/Linux
```bash
# Install dependencies (example for Ubuntu/Debian)
sudo apt-get install build-essential git
```

## Quick Usage

```bash
# 1. Clone repository with submodules
git clone --recursive https://github.com/your-user/FreeBSD-userspace.git
cd FreeBSD-userspace

# 2. Run initial setup (optional)
./scripts/setup.sh

# 3. Build userspace for ARM64
./build.sh aarch64

# 4. Build userspace for x86_64
./build.sh amd64
```

## Project Structure

```
FreeBSD-userspace/
├── build.sh                    # Main build script
├── scripts/                    # Auxiliary scripts
│   ├── setup.sh               # Initial setup
│   ├── clean.sh               # Build cleanup
│   ├── validate.sh            # Environment/results validation
│   └── setup-hooks.sh         # Git hooks configuration
├── freebsd-src/               # Official FreeBSD repository submodule
├── configs/                   # Specific configurations
├── .githooks/                 # Git hooks for Conventional Commits
│   ├── commit-msg             # Commit format validation
│   └── README.md             # Hooks documentation
├── .gitmessage               # Commit template
├── obj/                       # Intermediate build objects
├── dist/                      # Extracted userspace (result)
└── docs/                      # Detailed documentation
```

## Result

After a successful build, the complete userspace will be available in `dist/`, ready to be used or packaged.

## Make Targets Used

- `buildworld`: Compiles the entire userspace
- `installworld`: Installs userspace to destination directory

## Custom Configurations

The project includes optimized configurations in `configs/`:
- `src.conf.minimal`: Minimal configuration to reduce components
- `make.conf.cross`: Configuration for cross-compilation

## Development

### Conventional Commits

This project uses [Conventional Commits](https://www.conventionalcommits.org/) to standardize commit messages:

```bash
# Configure automatic hooks
./scripts/setup-hooks.sh

# Examples of valid commits
git commit -m "feat(userspace): add ARM64 support"
git commit -m "fix(build): resolve dependency issue"
git commit -m "docs: update installation guide"
```

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

## License

This project follows the same BSD license as the original FreeBSD.
