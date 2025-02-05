#!/bin/bash

# Monitor resolutions (width x height)
s1=1080x1920    # Left (portrait)
s2=2560x1440    # Middle
s3=1920x3000    # Right (tallest test case)

# Manual offset -> the script centers to tallest screen by default
# o1=200 -> first screen down by 200px and -200 -> 200px up
o1=0
o2=0
o3=0

screens=("$s1" "$s2" "$s3")
offsets=("$o1" "$o2" "$o3")

# Use arrays to store dimensions cleanly
# width, height, box -> the spacer height on top of each image
declare -a w h b

# Extract widths, heights using array indices
for i in "${!screens[@]}"; do
 IFS='x' read -r w[i] h[i] <<< "${screens[i]}"
done

# Find maximum height
hm=$(printf "%s\n" "${h[@]}" | sort -n | tail -n1)

# Set value for box heights -> we need hm for this
for i in "${!h[@]}"; do
	b[i]=$((( (hm - h[i]) / 2 )+${offsets[i]}))
done

# Literally magick

cmd=""
for i in "${!screens[@]}"; do
    printf -v fragment '\( -size %sx%s xc:none -append \( %d.jpg -resize %s! \) -append \)' \
        "${w[i]}" "${b[i]}" "$((i+1))" "${screens[i]}"
    cmd+=" $fragment"
done

# Execute with proper quoting using eval
eval "magick -background none $cmd +append wallpaperNew.jpg"

# This 'totally' useful loop is basically a product of
# 
# “Your scientists were so preoccupied with whether they could,
# they didn’t stop to think if they should.”
#
# I still like to think its a bit cool
#
# 1. initialize an empty string
# 2. loop through the screen array indices
# 3. use printf -v (to store in a variable)
# 	- store in the temp string 'fragment'
# 	- replace %s -> strings and %d -> decimals
# 	- concatenate cmd to store as many images as needed
# 4. eval end result to get magick to actually execute $cmd


