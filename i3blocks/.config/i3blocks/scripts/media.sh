#!/bin/bash

# Function to get the current song's artist and title
song_metadata() {
    playerctl metadata --format "{{ artist }} <span color=\"#bd93f9\">-</span> {{ title }}"
}

# Function to get the current volume
get_volume() {
    # Get the current volume level (0 to 100) from PulseAudio
     pactl get-sink-volume @DEFAULT_SINK@ | awk '{gsub("%", ""); print $5}'
}

# Function to set the volume
set_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ "$1"
}

# Function to handle the previous song
previous_song() {
    playerctl previous
}

# Function to handle the next song
next_song() {
    playerctl next
}

# Function to toggle play/pause
toggle_pause() {
    playerctl play-pause
}

# Function to change the volume based on scroll direction
adjust_volume() {
    current_volume=$(get_volume)

    if [ "$1" -eq 4 ]; then  # Scroll up (increase volume)
        new_volume=$((current_volume + 5))
        if [ "$new_volume" -le 100 ]; then
            set_volume "${new_volume}%"
        fi
    elif [ "$1" -eq 5 ]; then  # Scroll down (decrease volume)
        new_volume=$((current_volume - 5))
        if [ "$new_volume" -ge 0 ]; then
            set_volume "${new_volume}%"
        fi
    fi
}

# Function to get the volume icon based on the current volume
get_volume_icon() {
    current_volume=$(get_volume)
    
    if [ "$current_volume" -eq 0 ]; then
        echo "🔇"  # Muted Speaker
    elif [ "$current_volume" -le 30 ]; then
        echo "🔈"  # Speaker Low Volume
    elif [ "$current_volume" -le 60 ]; then
        echo "🔉"  # Speaker Medium Volume
    else
        echo "🔊"  # Speaker High Volume
    fi
}

# Display metadata along with the volume (headphone emoji) and volume icon
echo "🎧 $(song_metadata) $(get_volume_icon) $(get_volume)%"

# Handle mouse click actions
case $BLOCK_BUTTON in
    1) # Left click (Previous song)
        previous_song
        ;;
    2) # Middle click (Pause/Play)
        toggle_pause
        ;;
    3) # Right click (Next song)
        next_song
        ;;
    4) # Scroll up (Increase volume)
        adjust_volume 4
        ;;
    5) # Scroll down (Decrease volume)
        adjust_volume 5
        ;;
    *)
        ;;
esac

