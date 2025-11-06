#!/bin/bash
set -e

echo "🚀 Running BeforeInstall hook..."

# Example: Create target directory if not exists
mkdir -p /opt/bank-app/scripts/

# Copy existing scripts to the target location
cp -r /opt/scripts/* /opt/bank-app/scripts/

# Optional: adjust ownership/permissions
chmod -R 755 /opt/bank-app/scripts/
# chown -R ec2-user:ec2-user /opt/bank-app/scripts/

echo "✅ Scripts copied successfully to /opt/bank-app/scripts/"
