#!/bin/bash
# Durations (in seconds)
POMODORO_DURATION=1500    # 25 minutes
SHORT_BREAK_DURATION=300  # 5 minutes
LONG_BREAK_DURATION=1200  # 20 minutes

# Files for state tracking
CYCLE_FILE="/tmp/pomodoro_cycle"   # Holds the current work cycle number (1..4)
PHASE_FILE="/tmp/pomodoro_phase"     # "work" or "break"
TIMER_FILE="/tmp/pomodoro_timer"     # Unix timestamp when current phase ends
STATE_FILE="/tmp/pomodoro_state"     # For pausing/resuming

# --- Initialization ---
# Get current work cycle (default to 1)
if [ -f "$CYCLE_FILE" ]; then
  work_cycle=$(cat "$CYCLE_FILE")
else
  work_cycle=1
fi

# Get current phase (default to work)
if [ -f "$PHASE_FILE" ]; then
  phase=$(cat "$PHASE_FILE")
else
  phase="work"
fi

# --- Handle Mouse Clicks ---
case "$BLOCK_BUTTON" in
  1)
    # Left-click: start/pause/resume
    if [ -f "$TIMER_FILE" ]; then
      # Running → pause: save remaining time
      remaining=$(( $(cat "$TIMER_FILE") - $(date +%s) ))
      echo "$remaining" > "$STATE_FILE"
      rm -f "$TIMER_FILE"
    elif [ -f "$STATE_FILE" ]; then
      # Paused → resume: set new timer based on stored remaining time
      remaining=$(cat "$STATE_FILE")
      echo $(( $(date +%s) + remaining )) > "$TIMER_FILE"
      rm -f "$STATE_FILE"
    else
      # Not running: start a new work session
      echo "1" > "$CYCLE_FILE"
      echo "work" > "$PHASE_FILE"
      echo $(( $(date +%s) + POMODORO_DURATION )) > "$TIMER_FILE"
      work_cycle=1
      phase="work"
    fi
    ;;
  2)
    # Middle-click: Skip current phase
    rm -f "$TIMER_FILE" "$STATE_FILE"
    if [ "$phase" = "work" ]; then
      # Skip work → move to break without changing work_cycle.
      echo "break" > "$PHASE_FILE"
      phase="break"
      if [ "$work_cycle" -lt 4 ]; then
        echo $(( $(date +%s) + SHORT_BREAK_DURATION )) > "$TIMER_FILE"
      else
        echo $(( $(date +%s) + LONG_BREAK_DURATION )) > "$TIMER_FILE"
      fi
    else
      # Skip break → move to work.
      # Now update work_cycle: increment if less than 4; if 4, wrap to 1.
      if [ "$work_cycle" -lt 4 ]; then
        work_cycle=$(( work_cycle + 1 ))
      else
        work_cycle=1
      fi
      echo "$work_cycle" > "$CYCLE_FILE"
      echo "work" > "$PHASE_FILE"
      phase="work"
      echo $(( $(date +%s) + POMODORO_DURATION )) > "$TIMER_FILE"
    fi
    ;;
  3)
    # Right-click: Full reset
    rm -f "$TIMER_FILE" "$STATE_FILE" "$CYCLE_FILE" "$PHASE_FILE"
    ;;
esac

# --- Timer Logic & Transitions ---
if [ -f "$TIMER_FILE" ]; then
  remaining=$(( $(cat "$TIMER_FILE") - $(date +%s) ))
  if [ $remaining -le 0 ]; then
    # Timer expired—transition to next phase.
    rm -f "$TIMER_FILE"
    if [ "$phase" = "work" ]; then
      # Work finished → transition to break (use current work_cycle to label)
      echo "break" > "$PHASE_FILE"
      phase="break"
      if [ "$work_cycle" -lt 4 ]; then
        echo $(( $(date +%s) + SHORT_BREAK_DURATION )) > "$TIMER_FILE"
        display="☕ Break #$work_cycle (5m)"
      else
        echo $(( $(date +%s) + LONG_BREAK_DURATION )) > "$TIMER_FILE"
        display="☕ Long Break (20m)"
      fi
    else
      # Break finished → transition to work; update work cycle
      if [ "$work_cycle" -lt 4 ]; then
        work_cycle=$(( work_cycle + 1 ))
      else
        work_cycle=1
      fi
      echo "$work_cycle" > "$CYCLE_FILE"
      echo "work" > "$PHASE_FILE"
      phase="work"
      echo $(( $(date +%s) + POMODORO_DURATION )) > "$TIMER_FILE"
      display="🍅 Work #$work_cycle"
    fi
  else
    # Timer still running: set display message based on phase
    if [ "$phase" = "work" ]; then
      display="🍅 Work #$work_cycle $(date -u -d @$remaining +%M:%S)"
    else
      if [ "$work_cycle" -lt 4 ]; then
        display="☕ Break #$work_cycle (5m) $(date -u -d @$remaining +%M:%S)"
      else
        display="☕ Long Break (20m) $(date -u -d @$remaining +%M:%S)"
      fi
    fi
  fi
  echo "$display"
elif [ -f "$STATE_FILE" ]; then
  # Timer is paused.
  if [ "$phase" = "work" ]; then
    echo "⏸️ Paused (Work #$work_cycle)"
  else
    if [ "$work_cycle" -lt 4 ]; then
      echo "⏸️ Paused (Break #$work_cycle)"
    else
      echo "⏸️ Paused (Long Break)"
    fi
  fi
else
  echo "🍅 Start"
fi

