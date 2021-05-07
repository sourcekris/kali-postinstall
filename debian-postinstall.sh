#!/bin/bash
#-Metadata-----------------------------------------------------------------
# Filename: kali-postinstall.sh
# Date: 2021-05-07
# Version: 10.9.0
#-Notes--------------------------------------------------------------------
# These are the things I do after install Debian on a new VM/System. 
#
# Run this with sudo after installation.
# 
# This is provided as-is and is not meant for others. However, you might 
# find some of this stuff useful. Got some of these ideas from g0tm1lk,
# see his script at:
#
# https://github.com/g0tmi1k/os-scripts/blob/master/kali.sh
#
# Tweet @CTFKris for ideas to add to this.
#

VERSION="10.9.0"

# Path to download packages, XPI's etc to
SCRIPTDLPATH="scriptdls/"

# CinnamonSpices URL
CINNAMONSPICES="https://cinnamon-spices.linuxmint.com"

# We do VM detection later, default case it false, set manually to true if the 
# detection fails for you
VM=false

# Terminal Palette
TERMPAL="['#2E3436','#CC0000','#4E9A06','#C4A000','#3465A4','#75507B','#06989A','#D3D7CF','#555753','#EF2929','#8AE234','#FCE94F','#729FCF','#AD7FA8','#34E2E2','#EEEEEC']"
TERMBG="#000000"
TERMFG="#FFFFDD"

# People were running "sh kali-postinstall.sh" and this broke tests
if test "$_" = "/bin/sh"
then
    echo "Found to be running in /bin/sh. Its better to run this script in /bin/bash"
    echo "Usage: ./$0"
    exit
fi

# Check we're root
if [[ $EUID -ne 0 ]]
then
	echo "[-] This script must be run as root." 
	exit
fi

echo "[*] Improving Debian $VERSION"

mkdir "$SCRIPTDLPATH" 2>/dev/null

if [[ `dmidecode | grep -ic virtual` -gt 0 ]]
then
	VM=true
fi

echo "[+] Installing VS Code..."
wget -qO "$SCRIPTDLPATH/code.deb" https://go.microsoft.com/fwlink/?LinkID=760868
apt install "$SCRIPTDLPATH/code.deb"

echo "[+] Updating repos..."
apt-get -qq update

if [ "$VM" == "true" ]
then
	echo "[+] Installing open-vm-tools..."
	apt-get -y -qq install open-vm-tools-desktop fuse 
fi

echo "[+] Downloading theme and icons..."
THEMEFILE=`wget -qO - "$CINNAMONSPICES"/json/themes.json | jq '."Adapta-Nokto".file' | sed -e s/\"//g`
wget -qO "$SCRIPTDLPATH/theme.zip" "$CINNAMONSPICES$THEMEFILE"
wget -qO "$SCRIPTDLPATH/icons.deb" http://ftp.iinet.net.au/pub/ubuntu/pool/main/h/humanity-icon-theme/humanity-icon-theme_0.6.15_all.deb


echo "[+] Installing theme, icons..."
cd "$SCRIPTDLPATH"
dpkg -i icons.deb
unzip -qq -d /usr/share/themes theme.zip

cd ../
cp themefiles/kalibg.png /usr/share/backgrounds
cp .vimrc ~


echo "[+] Installing more packages..."
apt-get -y -qq install python3-pip libgmp-dev libssl-dev rustc gimp squashfs-tools pngcheck exiftool mongodb-clients sshpass libssl-dev pdfcrack tesseract-ocr zlib1g-dev vagrant strace ltrace dconf-editor

echo "[+] Installing pwntools..."
pip3 install pwntools

echo "[+] Installing xortool..."
pip3 install xortool

echo "[+] Installing gmpy..."
pip3 install gmpy

echo "[+] Installing sympy..."
pip3 install sympy

echo "[+] Installing libnum..."
pip3 install libnum

echo "[+] Installing impacket..."
pip3 install impacket

echo "[+] Installing pickleassem..."
pip3 install pickleassem

echo "[+] Installing Stegosolve..."
wget -qO /usr/bin/Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
chmod +x /usr/bin/Stegsolve.jar

echo "[+] Installing PEDA..."
git clone -q https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

# echo "[+] Cloning some important git repos..."
# mkdir gitrepos
# git clone -q https://github.com/BuffaloWill/oxml_xxe
# git clone -q https://github.com/sensepost/anapickle

#cd ../..

# echo "[+] Updating Metasploit..."
# apt-get -y -qq install metasploit-framework

# echo "[+] Updating wpscan..."
# wpscan --update

# echo "[+] Updating mate settings..."
# # Terminal 
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ help 'disabled' # hate hitting help accidently, noone cares
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/default/ scrollback-unlimited true	# unlimited terminal scrollback
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/default/ background-color $TERMBG
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/default/ foreground-color $TERMFG
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/default/  palette $TERMPAL

gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/default/  use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/default/  bold-color-same-as-fg false

# # Disable screensavers!
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false	# disable screensave
gsettings set org.cinnamon.settings-deamon.plugins.power sleep-display-ac 0	# disable screen sleeping when plugged in

# # Wallpaper settings
gsettings set org.gnome.desktop.background picture-options 'centered'		# set wallpaper options
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/kalibg.png'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background primary-color '#23231f1f2020'

# # Theme and fonts
# gsettings set org.mate.interface gtk-theme 'Arc-Dark'
# gsettings set org.mate.interface icon-theme 'Humanity-Dark'
# gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Dark'
# gsettings set org.mate.Marco.general theme 'Arc-Dark'
# gsettings set org.mate.font-rendering antialiasing 'rgba'
# gsettings set org.mate.font-rendering hinting 'slight'
# gsettings set org.mate.Marco.general titlebar-font 'Ubuntu Medium 11'
# gsettings set org.mate.interface monospace-font-name 'Ubuntu Mono 13'
# gsettings set org.mate.interface font-name 'Ubuntu 11'
# gsettings set org.mate.caja.desktop font 'Ubuntu 11'

echo "[+] Upgrading all packages..."
apt-get -y upgrade

# rm -fr "$SCRIPTDLPATH"
