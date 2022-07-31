#!/bin/bash
#-Metadata-----------------------------------------------------------------
# Filename: kali-postinstall.sh
# Date: 2022-07-28
# Version: 2022.2
#-Notes--------------------------------------------------------------------
# These are the things I do after install Kali on a new VM/System. 
#
# Run this as root after an install of Kali 
# 
# This is provided as-is and is not meant for others. However, you might 
# find some of this stuff useful. Got some of these ideas from g0tm1lk,
# see his script at:
#
# https://github.com/g0tmi1k/os-scripts/blob/master/kali.sh
#
# Tweet @CTFKris for ideas to add to this.
#

VERSION="2022.2"

# Path to download packages, etc to
SCRIPTDLPATH="scriptdls/"

# We do VM detection later, default case it false, set manually to true if the 
# detection fails for you
VM=false

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

echo "[*] Improving Kali $VERSION"
echo "[+] Updating repos and installing nala"
apt-get -qq update
apt -y -qq install nala # Use nala from here on out to gain package history.

echo "[+] Downloading ubuntu font..."
mkdir -p "$SCRIPTDLPATH"
wget -qO "$SCRIPTDLPATH/font.zip" https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
cd "$SCRIPTDLPATH"
unzip -qq -o -d /usr/share/fonts/truetype/ttf-ubuntu font.zip
fc-cache -f
cd ..

cp themefiles/kalibg.png /usr/share/backgrounds
cp .vimrc ~
chsh -s /bin/bash root

echo "[+] Installing VS Code..."
wget -qO "$SCRIPTDLPATH/code.deb" https://go.microsoft.com/fwlink/?LinkID=760868
cd "$SCRIPTDLPATH"
apt install ./code.deb
cd ..

echo "[+] Installing more packages..."
nala install -y python3 python3-pip evil-ssdp gimp squashfs-tools pngcheck exiftool sshpass libssl-dev pdfcrack tesseract-ocr zlib1g-dev vagrant strace ltrace

echo "[+] Installing pip packages for Python3..."
pip3 install pwntools xortool gmpy sympy libnum pycryptodome

echo "[+] Installing Stegosolve..."
wget -qO /usr/bin/Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
chmod +x /usr/bin/Stegsolve.jar

echo "[+] Installing PEDA..."
git clone -q https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

echo "[+] Updating Metasploit..."
nala install -y metasploit-framework

echo "[+] Updating wpscan..."
wpscan --update

echo "[+] Upgrading all packages..."
nala upgrade -y

rm -fr "$SCRIPTDLPATH"

# Change desktop background settings
MONITOR=$(xfconf-query -c xfce4-desktop -l | awk -F'/' '{print $3"/"$4}' | grep screen | grep -v -E "monitor[0-4]" | sort | uniq)
BG="/backdrop/$MONITOR/workspace0"
xfconf-query -c xfce4-desktop -p "$BG"/image-style -s 0 # Turn off image
xfconf-query -c xfce4-desktop -p "$BG"/color-style -s 0 # Solid color
xfconf-query -c xfce4-desktop -p "$BG"/rgba1 -t double -t double -t double -t double -s 0.1 -s 0 -s 0.1 -s 1 # Dark purple.

# Move panel-1 to bottom.
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=8;x=0;y=0" # snap to bottom

# Create top panel
xfconf-query -c xfce4-panel -p /panels -t int -t int -s 1 -s 2 # create panel2
xfconf-query -c xfce4-panel --create -p /panels/panel-2/position -t string -s "p=6;x=0;y=0" # snap to top
xfconf-query -c xfce4-panel --create -p /panels/panel-2/position-locked -t bool -s true
xfconf-query -c xfce4-panel --create -p /panels/panel-2/length -t int 100
xfconf-query -c xfce4-panel --create -p /panels/panel-2/size -t int 34

# Remove plugins 13,20,21,22 (cpugraph, sep, sep, actions) from panel-1 and add 21,22 to panel 2
VALS="$(seq -f "-t int -s %g" -s " " 8) $(seq -f "-t int -s %g" -s " " 10 12) -t int -s 9 $(seq -f "-t int -s %g" -s " " 14 19)"
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids $VALS
xfconf-query -c xfce4-panel -pn /panels/panel-2/plugin-ids -t int -s 21 -t int -s 22
xfconf-query -c xfce4-panel -pn /plugins/plugin-21/expand -t bool -s true				# expand
xfconf-query -c xfce4-panel -pn /plugins/plugin-21/style -t int -s 0					# transparent
xfconf-query -c xfce4-panel -pn /plugins/plugin-9/miniature-view -t bool -s true		# desktop switcher view
xfce4-panel -r # Restart to pickup new panel config.
