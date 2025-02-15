#!/bin/bash

# Get battery info using acpi or upower
if command -v acpi &> /dev/null; then
    BATTERY_INFO=$(acpi -b)
    PERCENTAGE=$(echo "$BATTERY_INFO" | grep -o '[0-9]*%' | tr -d '%')
    STATUS=$(echo "$BATTERY_INFO" | awk '{print $3}' | tr -d ',')
else
    BATTERY_PATH=$(upower -e | grep battery)
    PERCENTAGE=$(upower -i "$BATTERY_PATH" | grep 'percentage' | awk '{print $2}' | tr -d '%')
    STATUS=$(upower -i "$BATTERY_PATH" | grep 'state' | awk '{print $2}')
fi

# Define icons based on charge status
if [[ "$STATUS" == "charging" ]]; then
    ICON="⚡"
elif [[ $PERCENTAGE -ge 80 ]]; then
    ICON="🔋"
elif [[ $PERCENTAGE -ge 40 ]]; then
    ICON="⛔"
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

