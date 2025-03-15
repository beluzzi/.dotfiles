#!/bin/bash

# Get the network status using nmcli
INFO=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev | grep 'wifi\|ethernet')

# Extract fields correctly
IFS=":" read -r DEVICE TYPE STATE CONNECTION <<< "$INFO"

# Get current SSID
SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

# Display status based on connection state


if [[ "$STATE" == "connected" ]]; then
	case $TYPE in
		wifi)
   		echo "🛜 $SSID"
    		echo "Connected to $SSID"
		;;
		ethernet)
		echo "🌈"
		echo "Connected to ethernet"
		;;
	esac
else
    echo "⏹️ Disconnected"
    echo "No active connection"
fi


# Click actions
case $BLOCK_BUTTON in
    1) # Left click: Show available networks and connect
        CHOICE=$(nmcli -t -f SSID dev wifi | awk -F: '!seen[$1]++ && $1' | rofi -dmenu -p "WiFi Networks")
        [[ -n "$CHOICE" ]] && nmcli dev wifi connect "$CHOICE"
        ;;
    3) # Right click: Toggle WiFi
        nmcli radio wifi off && notify-send "WiFi Disabled" || nmcli radio wifi on && notify-send "WiFi Enabled"
        ;;
    2) # Middle click: Open nmcli connection editor
        nm-connection-editor &
        ;;
esac

