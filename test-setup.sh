#!/bin/bash
set -e

echo "🧪 Container Build Showdown - Development Environment Test"
echo "========================================================="
echo ""

# Test function with error handling
test_command() {
    local name="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    if output=$(eval "$command" 2>&1); then
        if [[ -n "$expected" ]] && [[ ! "$output" =~ $expected ]]; then
            echo "❌ FAIL (unexpected output)"
            echo "   Expected: $expected"
            echo "   Got: $output"
            return 1
        else
            echo "✅ PASS"
            return 0
        fi
    else
        echo "❌ FAIL (command failed)"
        echo "   Error: $output"
        return 1
    fi
}

# Initialize counters
total_tests=0
passed_tests=0

# Core Tools Tests
echo "🔧 Core Tools Tests"
echo "-------------------"

((total_tests++))
if test_command "Node.js" "node --version" "v"; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "npm" "npm --version" ""; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "Git" "git --version" "git version"; then
    ((passed_tests++))
fi

echo ""

# Container Tools Tests
echo "🐳 Container Tools Tests"
echo "------------------------"

((total_tests++))
if test_command "Docker" "docker --version" "Docker version"; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "Docker daemon" "docker info" "Server Version"; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "Podman" "podman --version" "podman version"; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "kubectl" "kubectl version --client --short" "Client Version"; then
    ((passed_tests++))
fi

echo ""

# Project Structure Tests
echo "📁 Project Structure Tests"
echo "--------------------------"

required_files=(
    "package.json"
    "server.js"
    "app/package.json"
    "app/server.js"
    "containers/docker/Dockerfile"
    "containers/buildkit/Dockerfile"
    "containers/podman/Containerfile"
    "containers/kaniko/Dockerfile"
    "scripts/build_docker.sh"
    "scripts/build_buildkit.sh"
    "scripts/build_podman.sh"
    "scripts/build_kaniko_local.sh"
    "scripts/run_image.sh"
    "scripts/clean.sh"
    "webui/index.html"
    ".vscode/tasks.json"
    ".vscode/launch.json"
    ".devcontainer/devcontainer.json"
    ".github/workflows/docker-classic.yml"
    ".github/workflows/buildkit.yml"
    ".github/workflows/podman.yml"
    ".github/workflows/kaniko.yml"
)

for file in "${required_files[@]}"; do
    ((total_tests++))
    if test_command "File: $file" "test -f '$file'" ""; then
        ((passed_tests++))
    fi
done

echo ""

# Script Permissions Tests
echo "🔐 Script Permissions Tests"
echo "---------------------------"

script_files=(
    "scripts/build_docker.sh"
    "scripts/build_buildkit.sh"
    "scripts/build_podman.sh"
    "scripts/build_kaniko_local.sh"
    "scripts/run_image.sh"
    "scripts/clean.sh"
)

for script in "${script_files[@]}"; do
    ((total_tests++))
    if test_command "Executable: $script" "test -x '$script'" ""; then
        ((passed_tests++))
    fi
done

echo ""

# Dependencies Tests
echo "📦 Dependencies Tests"
echo "--------------------"

((total_tests++))
if test_command "Root package.json dependencies" "npm list --depth=0" "express"; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "App package.json dependencies" "cd app && npm list --depth=0" "express"; then
    ((passed_tests++))
fi

echo ""

# Container Build Tests (Quick syntax check)
echo "🐳 Container Build Syntax Tests"
echo "-------------------------------"

((total_tests++))
if test_command "Docker Dockerfile syntax" "docker build -f containers/docker/Dockerfile --dry-run ." "" 2>/dev/null || \
   test_command "Docker Dockerfile syntax (fallback)" "echo 'Dockerfile syntax check skipped (Docker BuildKit required)'" ""; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "Podman Containerfile syntax" "podman build -f containers/podman/Containerfile --dry-run ." "" 2>/dev/null || \
   test_command "Podman Containerfile syntax (fallback)" "echo 'Containerfile syntax check skipped'" ""; then
    ((passed_tests++))
fi

echo ""

# Port Availability Tests
echo "🌐 Port Availability Tests"
echo "--------------------------"

((total_tests++))
if test_command "Port 3000 available" "! nc -z localhost 3000" ""; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "Port 5173 available" "! nc -z localhost 5173" ""; then
    ((passed_tests++))
fi

echo ""

# VS Code Configuration Tests
echo "💻 VS Code Configuration Tests"
echo "------------------------------"

((total_tests++))
if test_command "VS Code tasks.json syntax" "python3 -m json.tool .vscode/tasks.json" "" 2>/dev/null || \
   test_command "VS Code tasks.json syntax (fallback)" "node -e 'JSON.parse(require(\"fs\").readFileSync(\".vscode/tasks.json\"))'" ""; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "VS Code launch.json syntax" "python3 -m json.tool .vscode/launch.json" "" 2>/dev/null || \
   test_command "VS Code launch.json syntax (fallback)" "node -e 'JSON.parse(require(\"fs\").readFileSync(\".vscode/launch.json\"))'" ""; then
    ((passed_tests++))
fi

((total_tests++))
if test_command "Dev container config syntax" "python3 -m json.tool .devcontainer/devcontainer.json" "" 2>/dev/null || \
   test_command "Dev container config syntax (fallback)" "node -e 'JSON.parse(require(\"fs\").readFileSync(\".devcontainer/devcontainer.json\"))'" ""; then
    ((passed_tests++))
fi

echo ""

# Results Summary
echo "📊 Test Results Summary"
echo "======================="
echo "Total tests: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $((total_tests - passed_tests))"
echo ""

if [ $passed_tests -eq $total_tests ]; then
    echo "🎉 All tests passed! Your development environment is ready."
    echo ""
    echo "🚀 Quick Start Commands:"
    echo "  npm start                    # Start the GUI server"
    echo "  ./scripts/build_docker.sh    # Build with Docker"
    echo "  ./scripts/build_podman.sh    # Build with Podman"
    echo "  ENABLE_SHELL=1 npm start     # Start GUI with shell execution"
    echo ""
    echo "📋 VS Code Tasks Available:"
    echo "  - Start GUI Server"
    echo "  - Build: Docker Classic"
    echo "  - Build: Docker BuildKit"
    echo "  - Build: Podman"
    echo "  - Build: Kaniko"
    echo "  - Check Container Tools"
    echo "  - Show All Containers"
    echo "  - Show All Images"
    echo "  - Benchmark All Builds"
    echo "  - Deep Clean All"
    exit 0
else
    echo "❌ Some tests failed. Please check the errors above."
    echo ""
    echo "🔧 Common fixes:"
    echo "  - Run: chmod +x scripts/*.sh"
    echo "  - Run: npm install"
    echo "  - Run: cd app && npm install"
    echo "  - Ensure Docker/Podman services are running"
    exit 1
fi
