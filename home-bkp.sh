#!/bin/bash

# Backup the /home/ directory to the external SSD
# Directories to exclude defined in file at '/home/user/.bkp-exclude'

# --- Configuration ---
SOURCE_DIR="$HOME/"
# !! CHANGE THIS TO YOUR ACTUAL SSD MOUNT PATH AND BACKUP FOLDER !!
DEST_DIR="/path/to/external/media/mount/point"
EXCLUDE_FILE="$HOME/.bkp-exclude"
LOG_FILE="$HOME/.var/log/backup_log.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Print status to terminal
echo "[$TIMESTAMP] Starting home directory backup..."

# Append status to $LOG_FILE
echo "[$TIMESTAMP] Starting home directory backup..." >> "$LOG_FILE"

# --- The Rsync Command ---
# -a (archive), -P (partial, progress), --delete (mirroring)
rsync -aP --delete --exclude-from="$EXCLUDE_FILE" "$SOURCE_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1

# Update the TIMESTAMP variable
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Print the exit status of rsync to terminal
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Backup completed successfully."
else
    echo "[$TIMESTAMP] Backup **FAILED** with exit code $?."
fi

# Append the exit status of rsync to $LOG_FILE
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Backup completed successfully." >> "$LOG_FILE"
else
    echo "[$TIMESTAMP] Backup **FAILED** with exit code $?." >> "$LOG_FILE"
fi
