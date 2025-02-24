#!/bin/bash

# Directory where images are stored
IMAGE_DIR="$HOME/.dotfiles/scripts/lockscreens"

# Select a random image
IMAGE=$(find "$IMAGE_DIR" -type f -name "*.png" | shuf -n 1)

# Run i3lock with the selected image
i3lock -i "$IMAGE" --nofork --ignore-empty-password --no-unlock-indicator

