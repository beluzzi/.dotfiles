#!/bin/bash

# Default values for screen resolutions (width x height)
default_screen1=1080x1920  # Left (portrait)
default_screen2=2560x1440  # Middle
default_screen3=1920x1080  # Right

# Default offsets for screens
default_offset1=0
default_offset2=0
default_offset3=0

# Initialize arrays for storing screen resolutions, offsets, and images
declare -a screen_resolutions screen_offsets screen_widths screen_heights box_heights image_files

# Flags for manual and verbose modes
manual_mode=false
verbose_mode=false

# Function to display help message
display_help() {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "  This script generates wallpapers for multiple montitors."
  echo "  Running the script without arguments will use the default config."
  echo "  This can be changed at the very top of this file - useful for automation."
  echo "  In automatic mode the Script uses images 1.jpg..3.jpg."
  echo "  The script will automatically scale images to each screen size."
  echo "  By default images will be centered to the tallest image."
  echo "  This can be changed with offsets:"
  echo "  	200 will move an image down and -200 will move it up by 200px."
  echo ""
  echo "Options:"
  echo "  -m       Enable manual mode (prompt for screen resolutions, offsets, and images)"
  echo "  -v       Enable verbose mode (log all script actions)"
  echo "  -h       Show this help message"
  echo ""
  exit 0
}

# Log function for verbose mode
log() {
  if $verbose_mode; then echo "[LOG] $@"; fi
}

# Parse arguments for -m (manual), -v (verbose), and -h (help)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -m) manual_mode=true ;;
    -v) verbose_mode=true ;;
    -mv|-vm) manual_mode=true; verbose_mode=true ;;
    -h) display_help ;;
    *) echo "Invalid option: $1"; display_help ;;
  esac
  shift
  log "Parsing script arguments..."
done

log "Manual mode: $manual_mode, Verbose mode: $verbose_mode"

# Validate screen resolution format like 1920x1080
validate_resolution() {
  [[ "$1" =~ ^[0-9]+x[0-9]+$ ]]
}

# Validate offset to be a positive or negative integer
validate_offset() {
  [[ "$1" =~ ^-?[0-9]+$ ]]
}

# Validate screen number to be a positive nonzero integer
validate_screens() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
  echo "Error: ImageMagick (magick) is not installed. Please install it first."
  exit 1
fi
log "ImageMagick found."

# Manual mode: Get user input
if $manual_mode; then
  # Loop until a valid screen number is entered
  while true; do
    echo "How many screens/images do you want to manage?"
    read num_screens
    log "User input: $num_screens screens"

    if validate_screens "$num_screens"; then
      break
    else
      echo "Invalid number of screens. Please enter a valid positive integer."
    fi
  done

  # Loop through number of screens
  for ((i=0; i<num_screens; i++)); do
    # Loop until a valid resolution is entered
    while true; do
      echo "Enter resolution for screen $((i+1)) (default: 1920x1080):"
      read screen_resolution
      screen_resolution="${screen_resolution:-1920x1080}"

      if validate_resolution "$screen_resolution"; then
        screen_resolutions+=("$screen_resolution")
        break
      else
        echo "Invalid resolution format. Use WIDTHxHEIGHT (e.g., 1920x1080)."
      fi
    done

    # Loop until a valid offset is entered
    while true; do
      echo "Enter offset for screen $((i+1)) (default: 0):"
      read screen_offset
      screen_offset="${screen_offset:-0}"

      if validate_offset "$screen_offset"; then
        screen_offsets+=("$screen_offset")
        break
      else
        echo "Invalid offset. Please enter a valid integer (e.g., 0, -10, 20)."
      fi
    done

    # Loop until a valid image is entered
    default_image="$((i+1)).jpg"
    while true; do
      echo "Enter image file name for screen $((i+1)) (default: $default_image):"
      read -e image_file
      image_file="${image_file:-$default_image}"

      if [[ -f "$image_file" ]]; then
        image_files+=("$image_file")
        break
      else
        echo "Invalid image. File not found."
      fi
    done

    log "Screen $((i+1)): Resolution=${screen_resolutions[i]}, Offset=${screen_offsets[i]}, Image=${image_files[i]}"
  done
else
  log "Using predefined screen settings."
  screen_resolutions=("$default_screen1" "$default_screen2" "$default_screen3")
  screen_offsets=("$default_offset1" "$default_offset2" "$default_offset3")
  image_files=("1.jpg" "2.jpg" "3.jpg")

  # Ensure predefined images exist
  for img in "${image_files[@]}"; do
    if [[ ! -f "$img" ]]; then
      echo "Error: Image '$img' not found."
      exit 1
    fi
  done
fi

log "Final screen setup:"
for i in "${!screen_resolutions[@]}"; do
  log "Screen $((i+1)): Resolution=${screen_resolutions[i]}, Offset=${screen_offsets[i]}, Image=${image_files[i]}"
done

# Extract widths and heights using array indices
log "Extracting width and height values..."
for i in "${!screen_resolutions[@]}"; do
  IFS='x' read -r screen_widths[i] screen_heights[i] <<< "${screen_resolutions[i]}"
  log "Screen $((i+1)): Width=${screen_widths[i]}, Height=${screen_heights[i]}"
done

# Find maximum height for centering
log "Calculating maximum screen height..."
max_height=$(printf "%s\n" "${screen_heights[@]}" | sort -n | tail -n1)
log "Max screen height: $max_height"

# Set value for box heights
log "Calculating box heights for centering..."
for i in "${!screen_heights[@]}"; do
  box_heights[i]=$((( (max_height - screen_heights[i]) / 2 ) + ${screen_offsets[i]}))
  log "Screen $((i+1)): Box height=${box_heights[i]}"
done

# Build the 'magick' command to combine images
log "Building ImageMagick command..."
cmd=""
for i in "${!screen_resolutions[@]}"; do
  printf -v fragment '\( -size %sx%s xc:none -append \( %s -resize %s! \) -append \)' \
      "${screen_widths[i]}" "${box_heights[i]}" "${image_files[i]}" "${screen_resolutions[i]}"
  cmd+=" $fragment"
  log "Added command segment: $fragment"
done

# Execute the magick command to create the combined wallpaper
log "Executing ImageMagick command..."
if eval "magick -background none $cmd +append wallpaper.jpg"; then
  echo "Successfully created wallpaper.jpg."
  log "Wallpaper created successfully."
else
  echo "Failed to create wallpaper. Check for errors."
  log "ImageMagick execution failed."
  exit 1
fi
