#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Log file
LOG_FILE="setup.log"

# Redirect stdout and stderr to both terminal and log file
exec > >(tee -a "$LOG_FILE") 2>&1


# Color Definitions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging Functions

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


# Virtual Environment Setup

setup_virtualenv() {

    if [ -d ".venv" ]; then
        info "Existing virtual environment found."
    else
        info "Creating a new virtual environment..."
        python3 -m venv .venv
        success "Virtual environment created."
    fi

    info "Activating virtual environment..."
    source .venv/bin/activate
    success "Virtual environment activated."
}


# Upgrade pip

upgrade_pip() {
    info "Upgrading pip..."
    python -m pip install --upgrade pip
    success "pip upgraded successfully."
}

# Create .gitignore

create_gitignore() {

    if [ -f ".gitignore" ]; then
        warning ".gitignore already exists. Skipping creation."
        return
    fi

    info "Creating .gitignore file..."

    cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*.pyo
*.pyd

# Virtual Environment
.venv/
venv/
env/

# Distribution
build/
dist/
*.egg-info/

# IDE Files
.vscode/
.idea/

# Logs
*.log

# Environment Variables
.env

# Jupyter
.ipynb_checkpoints/

# OS Files
.DS_Store
Thumbs.db
EOF

    success ".gitignore created successfully."
}


# Install Python Packages

install_packages() {
    info "Installing required Python packages..."

    pip install pandas requests

    success "Packages installed successfully."
}


# Main Function
main() {

    info "Python Project Setup Started"

    setup_virtualenv
    upgrade_pip
    create_gitignore
    install_packages

    success "Setup completed successfully!"
    success "Log saved to: $LOG_FILE"
}

# Run main
main
