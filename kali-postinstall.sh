#!/bin/bash
#
# These are the things I do after install Kali 2016.1 on a new VM/System. 
# 
# This is provided as-is and is not meant for others. However, you might find
# some of this stuff useful.
#
# Tweet @CTFKris for ideas to add to this.
#
# Updated: 26-Jan-16
#

echo "[*] Improving Kali 2016.1 ..."
echo "[+] Setting local Aussie Kali mirror (mirror.aarnet.edu.au) ..."
sed -i "s/http\.kali\.org/mirror\.aarnet\.edu\.au\/pub\/kali/" /etc/apt/sources.list
echo "[+] Updating repos from new mirror..."
apt-get -qq update
echo "[+] Installing openvm tools and mate desktop..."
apt-get -y -qq install open-vm-tools-desktop fuse mate-core mate-desktop-environment-extra mate-desktop-environment-extras 
echo mate-session > ~/.xsession
echo "[+] Downloading themes and fonts..."
mkdir themedls 2>/dev/null
wget -q -P themedls/ http://ftp.iinet.net.au/pub/ubuntu/pool/main/u/ubuntu-themes/ubuntu-mono_14.04+15.10.20151001-0ubuntu1_all.deb
wget -q -P themedls/ http://ftp.iinet.net.au/pub/ubuntu/pool/main/h/humanity-icon-theme/humanity-icon-theme_0.6.10_all.deb
wget -q -P themedls/ http://ftp.iinet.net.au/pub/ubuntu/pool/main/u/ubuntu-font-family-sources/ttf-ubuntu-font-family_0.83-0ubuntu1_all.deb
wget -q -P themedls/ https://launchpad.net/~ravefinity-project/+archive/ubuntu/ppa/+files/ambiance-colors_15.10.1~wily~NoobsLab.com_all.deb
echo "[+] Installing themes and fonts..."
cd themedls
dpkg -i *.deb
cd ..
echo "[+] Cleaning up deb package dls..."
rm -fr themedls
echo "[+] Downloading firefox extensions..."
wget -q https://addons.mozilla.org/firefox/downloads/latest/310783/addon-310783-latest.xpi
wget -q https://addons.mozilla.org/firefox/downloads/latest/3899/addon-3899-latest.xpi
wget -q https://addons.mozilla.org/firefox/downloads/latest/92079/addon-92079-latest.xpi
wget -q https://addons.mozilla.org/firefox/downloads/latest/472577/addon-472577-latest.xpi
wget -q https://addons.mozilla.org/firefox/downloads/latest/51740/platform:5/addon-51740-latest.xpi
echo "[+] Downloading wallpaper to ~/Pictures/kalibg.png"
wget -q -O ~/Pictures/kalibg.png http://img11.deviantart.net/1cda/i/2015/294/f/b/kali_2_0__not_official__wallpaper_by_xxdigipxx-d9dw004.png

echo "[+] Installing more packages"
apt-get -y -qq install gimp squashfs-tools pngcheck exiftool mongodb-clients 
echo "[+] Installing pwntools"
pip install pwntools
echo "[+] Installing PEDA"
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

echo "[+] Updating Metasploit..."
msfupdate

echo "[+] Installing pentest.rb into Metasploit plugins..."
mkdir ~/.msf5/
mkdir ~/.msf5/plugins
wget -q -O ~/.msf5/plugins/pentest.rb https://raw.githubusercontent.com/darkoperator/Metasploit-Plugins/master/pentest.rb

echo "[+] Updating wpscan..."
wpscan --update

echo "[+] Upgrading packages..."
apt-get -y -qq upgrade

echo "[+] Updating mate settings"
# Terminal and screensaver
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ scrollback-unlimited true	# unlimited terminal scrollback
gsettings set org.mate.screensaver idle-activation-enabled false	# disable screensave
gsettings set org.mate.power-manager sleep-display-ac 0				# disable screen sleeping when plugged in

# Wallpaper settings
gsettings set org.mate.background picture-options 'centered'		# set wallpaper options
gsettings set org.mate.background picture-filename '/root/Pictures/kalibg.png'
gsettings set org.mate.background color-shading-type 'solid'
gsettings set org.mate.background primary-color '#23231f1f2020'

# Theme and fonts
gsettings set org.mate.interface gtk-theme 'Ambiance-Orange'
gsettings set org.mate.interface icon-theme 'ubuntu-mono-dark'
gsettings set org.mate.caja.desktop font 'Ubuntu 11'
gsettings set org.mate.interface monospace-font-name 'Ubuntu Mono 13'
gsettings set org.mate.interface font-name 'Ubuntu 11'
gsettings set org.mate.interface document-font-name 'Ubuntu 11'
gsettings set org.mate.Marco.general titlebar-font 'Ubuntu Medium 11'
gsettings set org.mate.font-rendering antialiasing 'rgba'
gsettings set org.mate.font-rendering hinting 'slight'

echo "[+] Installing firefox extensions..."
firefox *.xpi
rm -f *.xpi
echo "[*] You need to reboot for the vmtools to take effect."
