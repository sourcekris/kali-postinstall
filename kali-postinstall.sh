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

if [[ `dmidecode | grep -ic virtual` -gt 0 ]]
then
	echo "[*] Running in a VM"
	VM=true
fi

echo "[+] Updating repos and installing nala"
apt-get -qq update
apt -y -qq install  nala # Use nala from here on out to gain package history.

if [ "$VM" == "true" ]
then
	echo "[+] Installing open-vm-tools..."
	nala install open-vm-tools-desktop fuse 
else
	echo "[*] Virtual machine NOT detected, skipping vmtools installation..."
fi

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
nala install python3 python3-pip evil-ssdp gimp squashfs-tools pngcheck exiftool sshpass libssl-dev pdfcrack tesseract-ocr zlib1g-dev vagrant strace ltrace

echo "[+] Installing pip packages for Python3..."
pip3 install pwntools xortool gmpy sympy libnum pycryptodome

echo "[+] Installing Stegosolve..."
wget -qO /usr/bin/Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
chmod +x /usr/bin/Stegsolve.jar

echo "[+] Installing PEDA..."
git clone -q https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

echo "[+] Updating Metasploit..."
nala install metasploit-framework

echo "[+] Updating wpscan..."
wpscan --update

echo "[+] Upgrading all packages..."
nala upgrade

rm -fr "$SCRIPTDLPATH"
