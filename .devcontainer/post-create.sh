#!/bin/bash
set -e

echo "🚀 Setting up Container Build Showdown development environment..."

# Update package lists
echo "📦 Updating package lists..."
sudo apt-get update

# Install dependencies for Podman
echo "🔧 Installing Podman dependencies..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    uidmap

# Add Podman repository
echo "📥 Adding Podman repository..."
. /etc/os-release
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -

# Install Podman
echo "🐳 Installing Podman..."
sudo apt-get update
sudo apt-get install -y podman

# Configure Podman for rootless operation
echo "🔒 Configuring Podman for rootless operation..."
echo 'unqualified-search-registries = ["docker.io"]' | sudo tee /etc/containers/registries.conf
mkdir -p ~/.config/containers
echo 'unqualified-search-registries = ["docker.io"]' > ~/.config/containers/registries.conf

# Install additional tools
echo "🛠️ Installing additional development tools..."
sudo apt-get install -y \
    jq \
    yq \
    tree \
    htop \
    git-lfs \
    shellcheck

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Verify installations
echo "✅ Verifying installations..."
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Docker version: $(docker --version || echo 'Docker not available')"
echo "Podman version: $(podman --version || echo 'Podman installation failed')"
echo "kubectl version: $(kubectl version --client --short || echo 'kubectl not available')"

# Set up helpful aliases
echo "🔧 Setting up helpful aliases..."
cat >> ~/.bashrc << 'EOF'

# Container Build Showdown aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias dps='docker ps'
alias dimg='docker images'
alias pps='podman ps'
alias pimg='podman images'
alias k='kubectl'
alias buildall='./scripts/build_docker.sh && ./scripts/build_buildkit.sh && ./scripts/build_podman.sh && ./scripts/build_kaniko_local.sh'

# Helpful functions
containers() {
    echo "=== Docker Containers ==="
    docker ps -a 2>/dev/null || echo "Docker not available"
    echo ""
    echo "=== Podman Containers ==="
    podman ps -a 2>/dev/null || echo "Podman not available"
}

images() {
    echo "=== Docker Images ==="
    docker images 2>/dev/null || echo "Docker not available"
    echo ""
    echo "=== Podman Images ==="
    podman images 2>/dev/null || echo "Podman not available"
}
EOF

# Make scripts executable
echo "🔐 Making scripts executable..."
chmod +x scripts/*.sh 2>/dev/null || echo "Scripts directory not found, will be created later"

echo "🎉 Container Build Showdown development environment setup complete!"
echo ""
echo "Available tools:"
echo "  - Node.js $(node --version)"
echo "  - Docker (via Docker-in-Docker)"
echo "  - Podman $(podman --version 2>/dev/null || echo 'installation pending')"
echo "  - kubectl $(kubectl version --client --short 2>/dev/null || echo 'available')"
echo ""
echo "Try these commands:"
echo "  - npm start                    # Start the GUI"
echo "  - ./scripts/build_docker.sh    # Build with Docker"
echo "  - ./scripts/build_podman.sh    # Build with Podman"
echo "  - containers                   # Show all containers"
echo "  - images                       # Show all images"
echo ""
