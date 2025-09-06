#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if two arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <target_base_directory> <deployment_name>"
  exit 1
fi

TARGET_BASE_DIR="$1"
DEPLOY_NAME="$2"
FULL_DEPLOY_PATH="$TARGET_BASE_DIR/$DEPLOY_NAME"

echo "Creating deployment directory: $FULL_DEPLOY_PATH"
mkdir -p "$FULL_DEPLOY_PATH"

echo "Copying deployment scripts..."
cp docker-compose.yml "$FULL_DEPLOY_PATH/"
cp ci-pull.sh "$FULL_DEPLOY_PATH/"
cp ci-start.sh "$FULL_DEPLOY_PATH/"
cp ci-stop.sh "$FULL_DEPLOY_PATH/"
cp ci-logs.sh "$FULL_DEPLOY_PATH/"

echo "Copying .env.template to .env and setting variables... (in $FULL_DEPLOY_PATH)"
cp .env.template "$FULL_DEPLOY_PATH/.env"

# Read PROXY_APP_NAME and PROXY_HOSTNAME from the original .env.template
PROXY_APP_NAME=$(grep "^PROXY_APP_NAME=" .env.template | cut -d'=' -f2)
PROXY_DOMAIN=$(grep "^PROXY_DOMAIN=" .env.template | cut -d'=' -f2)
PROXY_HOSTNAME=$(grep "^PROXY_HOSTNAME=" .env.template | cut -d'=' -f2)

# Replace the values in the new .env file
sed -i '' "s/^PROXY_APP_NAME=.*/PROXY_APP_NAME=$DEPLOY_NAME/" "$FULL_DEPLOY_PATH/.env"
sed -i '' "s/^PROXY_HOSTNAME=.*/PROXY_HOSTNAME=$DEPLOY_NAME.$PROXY_DOMAIN/" "$FULL_DEPLOY_PATH/.env"

echo "🚀 Deployment directory $FULL_DEPLOY_PATH has been created and configured."
cd "$FULL_DEPLOY_PATH" || exit 1 # Change to the deployment directory, exit if cd fails

echo "Running pull script..."
bash "./ci-pull.sh"

echo "Running start script..."
bash "./ci-start.sh"

echo "Running log script for 10 seconds..."

# Check if gtimeout is available (for macOS with coreutils)
if command -v gtimeout &> /dev/null
then
    TIMEOUT_CMD="gtimeout"
else
    # Fallback to timeout (for Linux and other systems)
    TIMEOUT_CMD="timeout"
fi
$TIMEOUT_CMD 10 bash "./ci-logs.sh"

echo "Container $PROXY_APP_NAME should be up 🔥 and running."
