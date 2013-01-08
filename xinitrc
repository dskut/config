
for dir in /usr/share/fonts/*; do xset +fp $dir; done && xset fp rehash

xrdb -merge ~/.Xresources

#trayer --edge top --align right --SetDockType true --SetPartialStrut true \
#--expand true --width 10 --transparent true --tint 0x191970 --height 12 &

# disable beep
xset b 0

xscreensaver -no-splash &

~/bin/xrandr-2screens 

# set background color and cursor
xsetroot -cursor_name left_ptr
feh --bg-center pictures/Archlinux_on_the_wall_by_Zildj4n.jpg

/usr/bin/xmonad
