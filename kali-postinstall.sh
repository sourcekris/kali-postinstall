#!/bin/bash
#-Metadata-----------------------------------------------------------------
# Filename: kali-postinstall.sh
# Date: 2025-02-02
# Version: 2024.4
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

export BASEPATH=`pwd`

source $BASEPATH/modules/common.sh

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

# install_font
# install_bg
# install_vimrc
# change_shell_to_bash

echo "[+] Installing VS Code..."
wget -qO "$SCRIPTDLPATH/code.deb" https://go.microsoft.com/fwlink/?LinkID=760868
cd "$SCRIPTDLPATH"
apt install ./code.deb
cd ..

echo "[+] Installing more packages..."
nala install -y ghidra remmina python3 python3-pip evil-ssdp gimp squashfs-tools pngcheck exiftool sshpass libssl-dev pdfcrack tesseract-ocr zlib1g-dev vagrant strace ltrace

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

echo "[+] Cleanup after upgrade..."
rm -fr "$SCRIPTDLPATH"
nala install -y --fix-broken
nala autoremove -y