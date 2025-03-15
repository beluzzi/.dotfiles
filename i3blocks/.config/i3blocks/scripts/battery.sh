#!/bin/bash

# Check if battery exists
if [ ! -d /sys/class/power_supply/BAT0 ]; then
	#Change this to whatever - will be displayed on devices without battery
	echo "🔥 999%"   
else

# Get battery status and percentage
    STATUS=$(cat /sys/class/power_supply/BAT0/status)
    PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity)

# Define icons based on charge status
if [[ "$STATUS" == "charging" ]]; then
    ICON="⚡"
elif [[ $PERCENTAGE == 100 ]]; then
    ICON="💡"
elif [[ $PERCENTAGE == 42 ]]; then
    ICON="🐋"
elif [[ $PERCENTAGE -ge 60 ]]; then
    ICON="🔋"
elif [[ $PERCENTAGE -ge 20 ]]; then
    ICON="🪫"
elif [[ $PERCENTAGE -ge 0 ]]; then
    ICON="💣"
fi

# Output for i3blocks
echo "$ICON $PERCENTAGE%"
echo "$ICON $PERCENTAGE%"

# Set color based on battery level
if [[ $PERCENTAGE -le 20 ]]; then
    echo "#FF0000"  # Red for critical battery
elif [[ $PERCENTAGE -le 40 ]]; then
    echo "#FFA500"  # Orange for low battery
else
    echo "#FFFFFF"  # White for normal battery level
fi
fi


