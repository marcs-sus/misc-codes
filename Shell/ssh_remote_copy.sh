#!/bin/bash

# Read informations
read -p "Enter the server IP: " SERVER_IP
read -p "Enter the user name: " USERNAME
read -p "Enter the remote dir: " REMOTE_DIR
read -p "Enter the local dir: " LOCAL_DIR

# Check if local dir exists
if [ ! -d "$LOCAL_DIR" ]; then
	echo "Local directory doesn't exist."
	exit 1
fi

# Initialize dir copying
echo "Copying directory..."
scp -r "$USERNAME@$SERVER_IP:$REMOTE_DIR" "$LOCAL_DIR"

STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "Successfully copied dir!"
else
	echo "Error on copying the dir!"
fi

