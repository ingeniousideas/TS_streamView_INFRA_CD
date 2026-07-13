#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
	echo "No environment provided. Usage: ./deploy_deploy_podman.sh [dev|prod|test]"
	exit 1
fi

# Set the environment based on the argument
ENVIRONMENT=$1
export ENVIRONMENT

# Stop and remove existing containers
echo "Running compose down..."
podman-compose down

echo "setting environment variables..."
# Set FLASK_ENV based on the provided environment
if [ "$ENVIRONMENT" == "prod" ]; then
	export FLASK_ENV=production
	export BUILD_ENV=production
	PROFILE=production
elif [ "$ENVIRONMENT" == "test" ]; then
	export FLASK_ENV=testing
	export BUILD_ENV=testing
	PROFILE=testing
elif [ "$ENVIRONMENT" == "dev" ]; then
	export FLASK_ENV=development
	export BUILD_ENV=development
	PROFILE=development
else
	echo "Unknown environment: $ENVIRONMENT. Use 'prod', 'dev', or 'test'."
	exit 1
fi

echo "Starting application in env = $ENVIRONMENT with FLASK_ENV = $FLASK_ENV and profile $PROFILE..."

# Run Podman Compose with the selected environment file
echo "Building containers..."
if [ "$ENVIRONMENT" == "prod" ]; then
	podman-compose --profile $PROFILE up --build -d
elif [ "$ENVIRONMENT" == "test" ]; then
	podman-compose --profile $PROFILE up --build -d
elif [ "$ENVIRONMENT" == "dev" ]; then
	podman-compose --profile $PROFILE up --build
else
	echo "Unknown environment: $ENVIRONMENT. Use 'prod', 'dev', or 'test'."
	exit 1
fi

echo "Deployment complete :)"