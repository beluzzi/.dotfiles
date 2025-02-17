#!/bin/bash

# Get current time in Germany
german_time=$(TZ='Europe/Berlin' date "+%Y-%m-%d %H:%M")

# Check if it's DST (Daylight Saving Time)
if date +"%z" | grep -q "+0200"; then
    dst_status="🌻"
else
    dst_status="🍁"
fi

# Display the time and DST status
echo "$german_time ($dst_status)"

