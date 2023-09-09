{ hostname, wm-command }: ''
  if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
      eval $(dbus-launch --exit-with-session --sh-syntax)
  fi
  systemctl --user import-environment DISPLAY XAUTHORITY

  if command -v dbus-update-activation-environment >/dev/null 2>&1; then
      dbus-update-activation-environment DISPLAY XAUTHORITY
  fi

  ${
    if hostname == "mapa-desktop"
    then ''
      xrandr --output HDMI-0 --primary --mode 2560x1440 --rate 75.00
      xrandr --output DP-1 --mode 1920x1080 --rate 60.00 --right-of HDMI-0
    ''
    else ""
  }

  echo "running xinitrc" >> /home/mapa/xinitrc.log
  ${wm-command}
''
