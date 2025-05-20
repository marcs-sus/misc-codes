#!bin/bash

# Variables
SOURCE_DIR="folder2backup"
BACKUP_DIR="backups"
BACKUP_NAME="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

# Create backup folder if it doesn't exist
if [ ! -d $BACKUP_DIR ]; then
	mkdir $BACKUP_DIR
fi

# Backup and move to dir
tar -czvf backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz $SOURCE_DIR
mv $BACKUP_NAME $BACKUP_DIR

# Log into file
if [ ! -d log.txt ]; then
	touch log.txt
fi
echo "Backup Log: $(date)" >> log.txt

