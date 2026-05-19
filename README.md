# 🐳 Container Build Showdown

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-24%2B-blue.svg)](https://www.docker.com/)
[![Podman](https://img.shields.io/badge/Podman-4%2B-purple.svg)](https://podman.io/)
[![Kaniko](https://img.shields.io/badge/Kaniko-Latest-orange.svg)](https://github.com/GoogleContainerTools/kaniko)
[![VS Code](https://img.shields.io/badge/VS%20Code-Ready-007ACC.svg)](https://code.visualstudio.com/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF.svg)](https://github.com/features/actions)

A comprehensive VS Code–optimized demo project that compares and benchmarks four modern container build approaches in a real-world scenario.

## 🎯 Overview 

This project provides a hands-on comparison of four popular container build tools:

| <sub>Tool</sub> | <sub>Type</sub> | <sub>Key Features</sub> | <sub>Best For</sub> |
|------|------|--------------|----------|
| <sub>**🐳 Docker Classic**</sub> | <sub>Traditional</sub> | <sub>Stable, widely supported</sub> | <sub>Production environments</sub> |
| <sub>**⚡ BuildKit/Buildx**</sub> | <sub>Next-gen Docker</sub> | <sub>Advanced caching, secrets, multi-platform</sub> | <sub>Modern Docker workflows</sub> |
| <sub>**🔧 Podman**</sub> | <sub>Daemonless</sub> | <sub>Rootless, Docker-compatible, security-focused</sub> | <sub>Kubernetes, rootless containers</sub> |
| <sub>**☸️ Kaniko**</sub> | <sub>Kubernetes-native</sub> | <sub>No daemon required, secure builds in containers</sub> | <sub>CI/CD pipelines, Kubernetes</sub> |

## 🚀 Features

### Core Components
- **📱 Interactive Web GUI** - Visual interface for triggering builds and monitoring progress
- **🔧 Sample Node.js App** - Real application to containerize (`app/`)
- **📋 Four Build Approaches** - Optimized Dockerfiles for each tool
- **🛠️ Automation Scripts** - Ready-to-use build and deployment scripts
- **🔄 CI/CD Workflows** - GitHub Actions for each build tool
- **💻 VS Code Integration** - Tasks, launch configs, and dev container support
- **📊 Performance Tracking** - Built-in timing and comparison capabilities

### Development Experience
- **🐳 Dev Container** - Docker-in-Docker environment with all tools pre-installed
- **⚡ Hot Reload** - Live updates during development
- **🔒 Security Controls** - Configurable shell execution permissions
- **📝 Comprehensive Logging** - Detailed build outputs and error tracking

## 📋 Prerequisites

### Required
- **Node.js 18+** - For running the GUI backend and sample application
- **Git** - For cloning and version control

### Container Tools (at least one required)
- **Docker 24+** - For Docker Classic and BuildKit/Buildx approaches
- **Podman 4+** - For daemonless container builds
- **Kubernetes cluster** - For native Kaniko builds (optional, can run locally)

### Optional
- **VS Code** - For enhanced development experience with tasks and dev container
- **GitHub account** - For CI/CD workflows and container registry (GHCR)

## 🚀 Quick Start

### Option 1: Interactive GUI (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/containers-build-showdown.git
cd containers-build-showdown

# Install dependencies
npm install

# Start the GUI backend (serves at http://localhost:5173)
npm run dev
```

Open <http://localhost:5173> in your browser to access the interactive interface.

**🔒 Security Note**: By default, the GUI backend does NOT execute shell builds for security. To enable actual command execution:

```bash
ENABLE_SHELL=1 npm run dev
```

⚠️ **Warning**: Only enable shell execution on trusted machines as this allows the server to spawn shell commands.

### Option 2: Direct CLI Usage

```bash
# Build with different tools
./scripts/build_docker.sh      # Docker Classic approach
./scripts/build_buildkit.sh    # Docker BuildKit/Buildx with advanced features
./scripts/build_podman.sh      # Podman daemonless build
./scripts/build_kaniko_local.sh # Kaniko in local Docker container

# Run any built image
./scripts/run_image.sh buildshow/app:docker    # Run Docker-built image
./scripts/run_image.sh buildshow/app:buildkit  # Run BuildKit-built image
./scripts/run_image.sh buildshow/app:podman    # Run Podman-built image

# Clean up all images and containers
./scripts/clean.sh
```

## 🏗️ Project Structure

```
containers-build-showdown/
├── 📁 app/                          # Sample Node.js application
│   ├── package.json                 # App dependencies
│   └── server.js                    # Express server
├── 📁 containers/                   # Container build definitions
│   ├── docker/Dockerfile           # Classic Docker multi-stage build
│   ├── buildkit/Dockerfile         # BuildKit with cache mounts & secrets
│   ├── podman/Containerfile        # Podman-compatible build
│   └── kaniko/Dockerfile           # Kaniko-optimized build
├── 📁 scripts/                     # Build automation scripts
│   ├── build_docker.sh             # Docker classic build
│   ├── build_buildkit.sh           # BuildKit/Buildx build
│   ├── build_podman.sh             # Podman build
│   ├── build_kaniko_local.sh       # Local Kaniko execution
│   ├── run_image.sh                # Container execution
│   └── clean.sh                    # Cleanup utility
├── 📁 webui/                       # Web interface
│   └── index.html                  # Responsive GUI
├── 📁 .vscode/                     # VS Code configuration
│   ├── tasks.json                  # Build tasks
│   └── launch.json                 # Debug configurations
├── 📁 .devcontainer/               # Development container
│   └── devcontainer.json           # Docker-in-Docker setup
├── 📁 .github/workflows/           # CI/CD pipelines
│   ├── docker-classic.yml          # Docker CI workflow
│   ├── buildkit.yml                # BuildKit CI workflow
│   ├── podman.yml                  # Podman CI workflow
│   └── kaniko.yml                  # Kaniko CI workflow
├── server.js                       # GUI backend server
├── package.json                    # GUI dependencies
└── README.md                       # This file
```

## 🏷️ Image Naming Convention

### Local Development Tags

The build scripts create consistently named local images for easy comparison:

- `buildshow/app:docker` - Built with Docker Classic
- `buildshow/app:buildkit` - Built with Docker BuildKit/Buildx  
- `buildshow/app:podman` - Built with Podman
- `buildshow/app:kaniko` - Built with Kaniko (tar export if `--no-push`)

### Registry Tags (CI/CD)

For production deployments using GitHub Container Registry (GHCR):

```bash
# Set your registry path
export IMAGE_REPO=ghcr.io/<owner>/containers-build-showdown/app

# Tags follow semantic patterns:
# ghcr.io/<owner>/containers-build-showdown/docker:latest
# ghcr.io/<owner>/containers-build-showdown/buildkit:v1.0.0
# ghcr.io/<owner>/containers-build-showdown/podman:main
# ghcr.io/<owner>/containers-build-showdown/kaniko:pr-123
```

## 💻 VS Code Integration

### Tasks (Terminal → Run Task)

- **Start GUI Server** - Launch the web interface
- **Build: Docker Classic** - Traditional Docker build
- **Build: Docker BuildKit** - Advanced BuildKit features
- **Build: Podman** - Daemonless container build
- **Build: Kaniko** - Kubernetes-native build
- **Run Container** - Execute built container
- **Clean Images** - Remove all built artifacts
- **Build All Containers** - Sequential build with all tools

### Launch Configurations (F5 Debug)

- **Launch GUI Server** - Debug the web backend with `ENABLE_SHELL=1`
- **Launch Sample App** - Debug the containerized Node.js application

### Dev Container Features

- **🐳 Docker-in-Docker** - Full container build capability
- **📦 Pre-installed Tools** - Node.js, Docker, Podman, kubectl
- **🔧 VS Code Extensions** - Docker, Kubernetes, YAML support
- **🔄 Volume Mounting** - Persistent node_modules across rebuilds

## ☸️ Kaniko Registry Integration

### GitHub Actions (Recommended)

Use the automated workflow in `.github/workflows/kaniko.yml` for secure registry pushes:

- `secrets.GITHUB_TOKEN` - Available by default for GHCR with `permissions: packages: write`
- Automatic image tagging based on branch/PR
- Secure credential handling in CI environment

### Manual Registry Setup

For local registry pushes, configure authentication:

```bash
# GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Docker Hub
echo $DOCKER_TOKEN | docker login -u USERNAME --password-stdin

# Then run with push enabled
export IMAGE_REPO=your-registry/repo
./scripts/build_kaniko_local.sh
```

## 🐳 Container Build Specifications

### Docker Classic (`containers/docker/Dockerfile`)

Traditional multi-stage build optimized for reliability:

- **Base Images**: `node:18-alpine` for runtime, `node:18` for build
- **Build Strategy**: Standard layer caching, dependency installation
- **Security**: Non-root user, minimal attack surface
- **Size**: ~150MB final image

### BuildKit Enhanced (`containers/buildkit/Dockerfile`)

Next-generation Docker with advanced features:

- **Syntax**: `docker/dockerfile:1.7-labs` for latest features
- **Cache Mounts**: Persistent npm cache across builds (`--mount=type=cache`)
- **Secrets**: Secure `.npmrc` handling (`--mount=type=secret`)
- **Parallelization**: Concurrent stage execution
- **Size**: ~140MB with optimized layers

### Podman Daemonless (`containers/podman/Containerfile`)

Security-focused rootless container builds:

- **Compatibility**: Docker-syntax compatible Containerfile
- **Security**: Rootless execution, no daemon required
- **Integration**: Works with existing Docker tooling
- **Performance**: Comparable to Docker with security benefits

### Kaniko Kubernetes-Native (`containers/kaniko/Dockerfile`)

Container-native builds without privileged access:

- **Environment**: Runs inside containers/Kubernetes pods
- **Security**: No Docker daemon required, reduced attack surface
- **Caching**: Built-in layer and registry caching
- **Portability**: Cloud-native, works in any Kubernetes environment

## ⚡ Performance Comparison

### Build Time Benchmarks

Run all builds and compare performance:

```bash
# Time each build approach
time ./scripts/build_docker.sh
time ./scripts/build_buildkit.sh  
time ./scripts/build_podman.sh
time ./scripts/build_kaniko_local.sh

# Or use the automated benchmark
npm run benchmark  # (if implemented)
```

### Expected Performance Characteristics

| <sub>Tool</sub> | <sub>First Build</sub> | <sub>Subsequent Builds</sub> | <sub>Cache Efficiency</sub> | <sub>Parallel Stages</sub> |
|------|-------------|-------------------|------------------|-----------------|
| <sub>Docker Classic</sub> | <sub>Baseline</sub> | <sub>Good</sub> | <sub>Standard</sub> | <sub>Limited</sub> |
| <sub>BuildKit</sub> | <sub>+10-20%</sub> | <sub>Excellent</sub> | <sub>Advanced</sub> | <sub>Full</sub> |
| <sub>Podman</sub> | <sub>Similar</sub> | <sub>Good</sub> | <sub>Standard</sub> | <sub>Limited</sub> |
| <sub>Kaniko</sub> | <sub>+20-30%</sub> | <sub>Good</sub> | <sub>Registry-based</sub> | <sub>Moderate</sub> |

*Times vary based on system configuration and network conditions*

## 🛠️ Troubleshooting

### Common Issues

#### GUI Not Loading
```bash
# Check if server is running
curl http://localhost:5173/api/info

# Verify dependencies
npm install
npm run dev
```

#### Build Script Failures
```bash
# Check tool installation
docker --version
podman --version

# Verify script permissions
chmod +x scripts/*.sh

# Check available disk space
df -h
```

#### Kaniko Local Issues
```bash
# Ensure Docker is running for Kaniko container
docker ps

# Check Kaniko executor image
docker pull gcr.io/kaniko-project/executor:latest
```

### VS Code Dev Container Issues

If the dev container fails to start:

1. **Docker Desktop** - Ensure Docker Desktop is running
2. **Extensions** - Install "Dev Containers" extension
3. **Rebuild** - Use "Dev Containers: Rebuild Container" command
4. **Resources** - Allocate sufficient memory (4GB+ recommended)

## 🔧 Customization

### Adding New Build Tools

1. Create new Dockerfile in `containers/newtool/`
2. Add build script in `scripts/build_newtool.sh`
3. Update GUI with new tool option
4. Add GitHub Actions workflow

### Modifying the Sample App

The Node.js app in `app/` can be replaced with any application:

- Update `app/package.json` with new dependencies
- Modify `app/server.js` with your application logic
- Adjust Dockerfiles if different base images needed
- Update health check endpoints in workflows

### Environment Variables

Customize behavior with environment variables:

```bash
# GUI Server Configuration
ENABLE_SHELL=1          # Enable actual command execution
PORT=5173              # Change server port
NODE_ENV=production    # Production mode

# Build Configuration  
IMAGE_REPO=custom/repo  # Custom registry path
DOCKER_BUILDKIT=1      # Enable BuildKit for Docker
```

## 📚 Learning Resources

### Documentation Links

- [Docker BuildKit Documentation](https://docs.docker.com/build/buildkit/)
- [Podman Installation Guide](https://podman.io/docs/installation)
- [Kaniko Project Repository](https://github.com/GoogleContainerTools/kaniko)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)

### Related Projects

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Multi-stage Build Patterns](https://docs.docker.com/build/building/multi-stage/)
- [Container Security Guide](https://sysdig.com/blog/dockerfile-best-practices/)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Fork and clone
git clone https://github.com/yourusername/containers-build-showdown.git
cd containers-build-showdown

# Install dependencies
npm install

# Start development server
ENABLE_SHELL=1 npm run dev

# Make changes and test
./scripts/build_docker.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Docker](https://www.docker.com/) for container technology leadership
- [Podman](https://podman.io/) for daemonless innovation
- [Google Kaniko](https://github.com/GoogleContainerTools/kaniko) for secure container builds
- [VS Code](https://code.visualstudio.com/) for excellent development experience
- [GitHub Actions](https://github.com/features/actions) for reliable CI/CD

---

**⭐ Star this repository if it helped you understand container build tools!**