setxkbmap -option
#setxkbmap -layout fr -variant mac -option terminate:ctrl_alt_bksp
setxkbmap -layout us -option terminate:ctrl_alt_bksp

feh --bg-scale images/breaking-bad.jpg

xrdb -load ~/.Xresources

exec i3
