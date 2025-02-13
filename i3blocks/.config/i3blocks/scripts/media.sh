#!/bin/bash

# Define function to handle metadata display
get_metadata() {
    playerctl metadata --format "{{ artist }} <span color=\"#bd93f9\">-</span> {{ title }}"
}

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

# Define border styles
border="#bd93f9"
border_top=1
border_right=0
border_bottom=0
border_left=0

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

# Output metadata for the blocklet
echo "<span color=\"$border\">   </span> $(get_metadata)"

