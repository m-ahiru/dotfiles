#!/bin/bash

MESSAGE="Please update your system."
LOG_FILE="/var/log/pacman.log"
WEEK_SECONDS=604800

send_notification() {
    notify-send -u critical "$MESSAGE"
}

# Handle -o flag for on-demand notification
if [[ "$1" == "-o" ]]; then
    send_notification
    exit 0
fi

# Find last full system upgrade
last_update_line=$(grep -F "starting full system upgrade" "$LOG_FILE" | tail -n 1)

if [[ -z "$last_update_line" ]]; then
    send_notification
    exit 0
fi

# Extract ISO timestamp from first [] block only
timestamp=$(echo "$last_update_line" | grep -oP '^\[\K[^\]]+')

# Convert to epoch time
last_update_epoch=$(date -d "$timestamp" +%s 2>/dev/null)


# Handle invalid date parsing
if [[ -z "$last_update_epoch" ]]; then
    echo "Failed to parse timestamp: $timestamp"
    exit 1
fi

current_epoch=$(date +%s)

# Notify if it's been a week
if (( current_epoch - last_update_epoch >= WEEK_SECONDS )); then
    send_notification
fi
