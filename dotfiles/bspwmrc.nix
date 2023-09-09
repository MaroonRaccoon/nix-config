hostname: ''
#!/nix/store/96ky1zdkpq871h2dlk198fz0zvklr1dr-bash-5.1-p16/bin/sh

# pgrep -x sxhkd > /dev/null || sxhkd &

echo 'before monitors' >> /home/mapa/bspwmrc.log
${ 
  if hostname == "mapa-desktop" 
  then ''
    bspc monitor HDMI-0 -d 1 2 3 4 5
    bspc monitor DP-1 -d 6 7 8 9 0''
  else ''
    bspc monitor -d I II III IV V VI VII VIII IX X''
}
echo 'after monitors' >> ~/bspwmrc.log

bspc config border_width         2
bspc config window_gap          12

bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'

polybar -c ~/.config/polybar/polybar.ini example &

feh --bg-fill ~/img/jacato-blanket.jpg &

echo 'end' >> /home/mapa/bspwmrc.log

picom &
''
