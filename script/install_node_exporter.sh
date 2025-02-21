#!/bin/bash
set -e

# Variables
VERSION="1.9.0"
NODE_EXPORTER_DIR="node_exporter-${VERSION}.linux-amd64"
TARBALL="${NODE_EXPORTER_DIR}.tar.gz"
DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/${TARBALL}"

# Download the tarball
echo "Downloading Node Exporter ${VERSION}..."
wget ${DOWNLOAD_URL}

# Extract the tarball
echo "Extracting ${TARBALL}..."
tar -xvf ${TARBALL}

# Move the binary to /usr/local/bin
echo "Installing binary..."
sudo mv ${NODE_EXPORTER_DIR}/node_exporter /usr/local/bin/

# Optional: Clean up downloaded files and extracted directory
rm -rf ${TARBALL} ${NODE_EXPORTER_DIR}

# Create a dedicated user for node_exporter if it doesn't exist
if ! id -u node_exporter &>/dev/null; then
    echo "Creating node_exporter user..."
    sudo useradd --no-create-home --shell /bin/false node_exporter
fi

# Create the systemd service file
echo "Creating systemd service file..."
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable/start the service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling node_exporter service..."
sudo systemctl enable node_exporter

echo "Starting node_exporter service..."
sudo systemctl start node_exporter

echo "Node Exporter installation complete. Checking service status:"
sudo systemctl status node_exporter --no-pager
