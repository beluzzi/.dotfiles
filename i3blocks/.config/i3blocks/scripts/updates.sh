#!/bin/bash

# Get the number of available updates
if ! updates=$(paru -Qu 2>/dev/null | wc -l); then
    echo "Error"
    exit 1
fi

# Output the number of updates
if [ "$updates" -gt 0 ]; then
    echo "$updates updates"
    echo "$updates updates"
    echo "#FF0000"  # Red color for urgency
else
    echo "Up-to-date"
    echo "Up-to-date"
    echo "#00FF00"  # Green color when no updates
fi

