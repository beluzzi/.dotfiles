#!/bin/bash

playerctl metadata --format "{{ artist }} <span color=\"#bd93f9\">-</span> {{ title }}"

# Define function for previous track
previous_song() {
    playerctl previous
}

# Define function for next track
next_song() {
    playerctl next
}

# Define function for pause/play
toggle_pause() {
    playerctl play-pause
}

# Get mouse click actions
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
    *)
        ;;
esac
