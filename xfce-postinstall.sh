#!/bin/bash

# XFCE configuration changes, run only as the user you wish to change the settings of.

# Change desktop background settings
MONITOR=$(xfconf-query -c xfce4-desktop -l | awk -F'/' '{print $3"/"$4}' | grep screen | grep -v -E "monitor[0-4]" | sort | uniq)
BG="/backdrop/$MONITOR/workspace0"
xfconf-query -c xfce4-desktop -p "$BG"/image-style -s 0 # Turn off image
xfconf-query -c xfce4-desktop -p "$BG"/color-style -s 0 # Solid color
xfconf-query -c xfce4-desktop -pn "$BG"/rgba1 -t double -t double -t double -t double -s 0.1 -s 0 -s 0.1 -s 1 # Dark purple.

# Move panel-1 to bottom.
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=8;x=0;y=0" # snap to bottom

# Create top panel
xfconf-query -c xfce4-panel -p /panels -t int -t int -s 1 -s 2 # create panel2
xfconf-query -c xfce4-panel -pn /panels/panel-2/position -t string -s "p=6;x=0;y=0" # snap to top
xfconf-query -c xfce4-panel -pn /panels/panel-2/position-locked -t bool -s true
xfconf-query -c xfce4-panel -pn /panels/panel-2/length -t int -s 100
xfconf-query -c xfce4-panel -pn /panels/panel-2/size -t int -s 34

# Remove plugins 7,13,15,20,21,22 (cpugraph, sep, sep, actions) from panel-1 and add 21,22 to panel 2
VALS="$(seq -f "-t int -s %g" -s " " 7) $(seq -f "-t int -s %g" -s " " 23 26) $(seq -f "-t int -s %g" -s " " 10 12) -t int -s 9 -t int -s 14 $(seq -f "-t int -s %g" -s " " 16 19)"
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids $VALS
xfconf-query -c xfce4-panel -pn /panels/panel-2/plugin-ids -t int -s 21 -t int -s 22
xfconf-query -c xfce4-panel -pn /plugins/plugin-21/expand -t bool -s true				# expand
xfconf-query -c xfce4-panel -pn /plugins/plugin-21/style -t int -s 0					# transparent
xfconf-query -c xfce4-panel -pn /plugins/plugin-9/miniature-view -t bool -s true		# desktop switcher view
xfconf-query -c xfce4-panel -pn /plugins/plugin-11/grouping -t int -s 0		            # never group
xfconf-query -c xfce4-panel -pn /plugins/plugin-11/show-labels -t bool -s true		    # window labels

# add burpsuite, metasploit, ghidra and remmina launchers
xfconf-query -c xfce4-panel -pn /plugins/plugin-23 -t string -s "launcher"		        # burp
xfconf-query -c xfce4-panel -pn /plugins/plugin-24 -t string -s "launcher"		        # msfconsole
xfconf-query -c xfce4-panel -pn /plugins/plugin-25 -t string -s "launcher"		        # ghidra
xfconf-query -c xfce4-panel -pn /plugins/plugin-26 -t string -s "launcher"		        # remmina
mkdir -p ~/.config/xfce4/panel/launcher-23/ && cp /usr/share/applications/kali-burpsuite.desktop ~/.config/xfce4/panel/launcher-23/
mkdir -p ~/.config/xfce4/panel/launcher-24/ && cp /usr/share/applications/kali-msfconsole.desktop ~/.config/xfce4/panel/launcher-24/
mkdir -p ~/.config/xfce4/panel/launcher-25/ && cp /usr/share/applications/kali-ghidra.desktop ~/.config/xfce4/panel/launcher-25/
mkdir -p ~/.config/xfce4/panel/launcher-26/ && cp /usr/share/applications/org.remmina.Remmina.desktop ~/.config/xfce4/panel/launcher-26/
xfconf-query -c xfce4-panel -pn /plugins/plugin-23/items -t string -s "kali-burpsuite.desktop" -a
xfconf-query -c xfce4-panel -pn /plugins/plugin-24/items -t string -s "kali-msfconsole.desktop" -a
xfconf-query -c xfce4-panel -pn /plugins/plugin-25/items -t string -s "kali-ghidra.desktop" -a
xfconf-query -c xfce4-panel -pn /plugins/plugin-26/items -t string -s "org.remmina.Remmina.desktop" -a
xfce4-panel -r # Restart to pickup new panel config.