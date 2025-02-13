#!/bin/bash

POMODORO_DURATION=1500  # 25 minutes in seconds
TIMER_FILE="/tmp/pomodoro_timer"
STATE_FILE="/tmp/pomodoro_state"  # Tracks pause state

# Handle clicks
if [ "$BLOCK_BUTTON" == "1" ]; then
    # Left-click: Pause/Resume
    if [ -f "$TIMER_FILE" ]; then
        echo $(( $(cat "$TIMER_FILE") - $(date +%s) )) > "$STATE_FILE"
        rm -f "$TIMER_FILE"
    elif [ -f "$STATE_FILE" ]; then
        echo $(( $(date +%s) + $(cat "$STATE_FILE") )) > "$TIMER_FILE"
        rm -f "$STATE_FILE"
    else
        echo $(( $(date +%s) + POMODORO_DURATION )) > "$TIMER_FILE"
    fi
elif [ "$BLOCK_BUTTON" == "3" ]; then
    # Right-click: Reset timer
    rm -f "$TIMER_FILE" "$STATE_FILE"
fi

# Display Timer
if [ -f "$TIMER_FILE" ]; then
    REMAINING=$(( $(cat "$TIMER_FILE") - $(date +%s) ))
    if [ $REMAINING -le 0 ]; then
        rm -f "$TIMER_FILE"
        echo "⏳ Break Time!"
    else
        echo "🍅 $(date -u -d @$REMAINING +%M:%S)"
    fi
elif [ -f "$STATE_FILE" ]; then
    echo "⏸️ Paused"
else
    echo "🍅 Start"
fi

