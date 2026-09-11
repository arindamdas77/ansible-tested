#!/usr/bin/env bash

# ================================================================
# ANSIBLE SERVER MONITORING PROJECT INSTALLER
# ================================================================

set -u

PROJECT_NAME="ansible-monitoring"
PROJECT_DIR="$HOME/$PROJECT_NAME"

echo ""
echo "============================================================"
echo " ANSIBLE SERVER MONITORING PROJECT INSTALLER"
echo "============================================================"
echo ""

# ------------------------------------------------------------
# Check operating system
# ------------------------------------------------------------

echo "[1/10] Checking operating system..."

if [ ! -f /etc/os-release ]; then
    echo "ERROR: Cannot detect operating system."
    exit 1
fi

. /etc/os-release

echo "Detected OS: $PRETTY_NAME"
echo ""

# ------------------------------------------------------------
# Check sudo
# ------------------------------------------------------------

echo "[2/10] Checking sudo access..."

if ! sudo -v; then
    echo "ERROR: This installer requires sudo access."
    exit 1
fi

echo "OK: Sudo access available."
echo ""

# ------------------------------------------------------------
# Update package list
# ------------------------------------------------------------

echo "[3/10] Updating package repository..."

sudo apt-get update -y

echo "OK: Package repository updated."
echo ""

# ------------------------------------------------------------
# Install required packages
# ------------------------------------------------------------

echo "[4/10] Installing required packages..."

sudo apt-get install -y \
    ansible \
    python3 \
    python3-pip \
    openssh-client \
    sshpass \
    rsync \
    curl \
    wget \
    git \
    ca-certificates

echo ""
echo "OK: Required packages installed."
echo ""

# ------------------------------------------------------------
# Display versions
# ------------------------------------------------------------

echo "[5/10] Checking installed software..."

echo ""

echo "Python:"
python3 --version || true

echo ""

echo "Ansible:"
ansible --version | head -n 3 || true

echo ""

echo "SSH:"
ssh -V 2>&1 || true

echo ""

# ------------------------------------------------------------
# Create project directory
# ------------------------------------------------------------

echo "[6/10] Creating project directory..."

mkdir -p "$PROJECT_DIR"

mkdir -p "$PROJECT_DIR/playbooks"
mkdir -p "$PROJECT_DIR/inventory"
mkdir -p "$PROJECT_DIR/scripts"
mkdir -p "$PROJECT_DIR/logs"
mkdir -p "$PROJECT_DIR/reports"

echo "Project directory:"
echo "$PROJECT_DIR"

echo ""
echo "OK: Project structure created."
echo ""

# ------------------------------------------------------------
# Create ansible.cfg
# ------------------------------------------------------------

echo "[7/10] Creating Ansible configuration..."

ANSIBLE_CONFIG_FILE="$PROJECT_DIR/ansible.cfg"

if [ ! -f "$ANSIBLE_CONFIG_FILE" ]; then

    cat > "$ANSIBLE_CONFIG_FILE" << 'EOF'
[defaults]

inventory = ./inventory/hosts
host_key_checking = False
retry_files_enabled = False
interpreter_python = auto_silent

forks = 20
timeout = 30

stdout_callback = default
bin_ansible_callbacks = True

[ssh_connection]

pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
EOF

    echo "Created: $ANSIBLE_CONFIG_FILE"

else

    echo "INFO: ansible.cfg already exists."
    echo "Skipping to avoid overwriting your configuration."

fi

echo ""

# ------------------------------------------------------------
# Create inventory
# ------------------------------------------------------------

echo "[8/10] Checking inventory..."

INVENTORY_FILE="$PROJECT_DIR/inventory/hosts"

if [ ! -f "$INVENTORY_FILE" ]; then

    cat > "$INVENTORY_FILE" << 'EOF'
[servers]

# Example:
# server1 ansible_host=192.168.1.10 ansible_user=root
# server2 ansible_host=192.168.1.11 ansible_user=ubuntu

EOF

    echo "Created example inventory:"
    echo "$INVENTORY_FILE"

else

    echo "INFO: Inventory already exists."
    echo "Skipping to avoid overwriting your servers."

fi

echo ""

# ------------------------------------------------------------
# Create README
# ------------------------------------------------------------

echo "[9/10] Creating project README..."

README_FILE="$PROJECT_DIR/README.md"

if [ ! -f "$README_FILE" ]; then

    cat > "$README_FILE" << 'EOF'
# Ansible Server Monitoring

This project contains Ansible playbooks for monitoring multiple servers.

## Project Structure

```text
ansible-monitoring/
├── ansible.cfg
├── inventory/
│   └── hosts
├── playbooks/
├── scripts/
├── logs/
└── reports/
