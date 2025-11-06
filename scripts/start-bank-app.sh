#!/bin/bash

sudo chmod +x /opt/bank-app-start.sh

cat <<EOF | sudo tee /etc/systemd/system/bankapp.service
[Unit]
Description=Bank App Service
After=network.target

[Service]
User=root
WorkingDirectory=/opt
ExecStart=/opt/bank-app/scripts/bank-app-pull-latest.sh

Restart=on-failure
RestartSec=5
SuccessExitStatus=143

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable bankapp.service
sudo systemctl start bankapp.service
