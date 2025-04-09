#!/bin/bash

locale=$(setxkbmap -print | grep -c intl)

toggle() {
case $locale in
	1)
		$(setxkbmap -layout us)
		;;
	0)
		$(setxkbmap -layout us -variant intl)
		;;
esac
}

if [[ "$locale" == 1 ]]; then
	echo "🦊"
else
	echo "🐺"
fi

case $BLOCK_BUTTON in
	1)
		toggle
		;;
esac
