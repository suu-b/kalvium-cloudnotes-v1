#!/bin/bash

set -e

APP_DIR="/home/suub/cloudnotes"
VENV="$APP_DIR/venv"
SERVICE_NAME="cloudnotes"

# Update system
sudo apt update
sudo apt upgrade -y

# Install required packages
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    postgresql \
    postgresql-contrib \
    git

# Clone application
if [ ! -d "$APP_DIR" ]; then
    git clone YOUR_REPOSITORY_URL "$APP_DIR"
fi

cd "$APP_DIR"

# Create virtual environment
if [ ! -d "$VENV" ]; then
    python3 -m venv "$VENV"
fi

# Install dependencies
"$VENV/bin/pip" install --upgrade pip
"$VENV/bin/pip" install -r requirements.txt

# Create upload directory
mkdir -p "$APP_DIR/uploads"

# Create systemd service
sudo tee "/etc/systemd/system/$SERVICE_NAME.service" > /dev/null <<EOF
[Unit]
Description=CloudNotes Flask Application
After=network.target

[Service]
User=suub
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV/bin"
ExecStart=$VENV/bin/gunicorn --bind 0.0.0.0:5000 app:app
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


# Reload systemd
sudo systemctl daemon-reload

# Enable service at boot
sudo systemctl enable "$SERVICE_NAME"

# Start application
sudo systemctl restart "$SERVICE_NAME"

echo "CloudNotes setup complete!"
echo "Service status:"
sudo systemctl status "$SERVICE_NAME" --no-pager