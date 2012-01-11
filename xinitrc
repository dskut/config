
xset +fp /usr/share/fonts
xset fp rehash

xrdb -merge ~/.Xresources

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
--expand true --width 10 --transparent true --tint 0x191970 --height 12 &

# set background color and cursor
xsetroot -solid black -cursor_name left_ptr

xscreensaver -no-splash &

xmonad
