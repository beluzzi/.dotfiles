#!/bin/bash

# Set screen sizes
s1=1080x1920
s2=2560x1440
s3=1920x1080

# Extract the second part (height) from each variable
height1=$(echo $s1 | cut -d'x' -f2)
height2=$(echo $s2 | cut -d'x' -f2)
height3=$(echo $s3 | cut -d'x' -f2)

# Calculate the difference and divide by 2
box1=$(( (height1 - height2) / 2 ))
box2=$(( (height1 - height3) / 2 ))

# Literally magick
magick -background none \
1.jpg -resize $s1! \
\( -size ${box1}x${box1} xc:none +append \
	 \( 2.jpg -resize $s2! \) -append \) \
\( -size ${box2}x${box2} xc:none +append \
	\( 3.jpg -resize $s3! \) -append \) \
 +append wallpaperNew.jpg
