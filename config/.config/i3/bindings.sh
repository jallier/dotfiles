#! /bin/bash

# Run compton. Prevents screen tearing
compton --config ~/.config/compton.conf -b

# map caps lock to esc when pressed and super when held
setxkbmap -option "caps:super" && xcape -e 'Super_L=Escape'

