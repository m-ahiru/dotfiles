#!/bin/bash

# Location of pacman log
PACMAN_LOG="/var/log/pacman.log"

# Search for full system upgrade entries
# A full upgrade is typically logged with "starting full system upgrade"
last_upgrade=$(grep -i "starting full system upgrade" "$PACMAN_LOG" | tail -1)

if [[ -z "$last_upgrade" ]]; then
    echo "No full system upgrade found in pacman log."
else
    # Extract the timestamp from the log entry
    timestamp=$(echo "$last_upgrade" | awk '{print $1, $2}' | sed 's/\[//;s/\]//')
    echo "Last full system upgrade was on: $timestamp"
fi

