#!/bin/bash
#-Metadata-----------------------------------------------------------------
# Filename: kali-postinstall.sh
# Date: 2016-09-22
#-Notes--------------------------------------------------------------------
# These are the things I do after install Kali 2016.2 on a new VM/System. 
#
# Run this as root after an install of Kali 2016.2
# 
# This is provided as-is and is not meant for others. However, you might 
# find some of this stuff useful. Got some of these ideas from g0tm1lk,
# see his script at:
#
# https://github.com/g0tmi1k/os-scripts/blob/master/kali.sh
#
# Tweet @CTFKris for ideas to add to this.
#

# Path to download packages, XPI's etc to
SCRIPTDLPATH="scriptdls/"

# Kali mirror you prefer, Australians can use AARNet or Internode
KALIMIRROR="mirror\.aarnet\.edu\.au\/pub\/kali"

# We do VM detection later, default case it false, set manually to true if the 
# detection fails for you
VM=false

# Check we're root
if [ $EUID -ne 0 ]
then
	echo "[-] This script must be run as root." 
	exit 1
fi

echo "[*] Improving Kali 2016.2"

if [ `dmidecode | grep -ic virtual` -gt 0 ]
then
	VM=true
fi

echo "[+] Setting preferred Kali mirror - $KALIMIRROR ..."
sed -i "s/http\.kali\.org/$KALIMIRROR/" /etc/apt/sources.list
echo "[+] Updating repos from new mirror..."
apt-get -qq update

if [ "$VM" == "true" ]
then
	echo "[+] Installing open-vm-tools..."
	apt-get -y -qq install open-vm-tools-desktop fuse 
else
	echo "[*] Virtual machine NOT detected, skipping vmtools installation..."
fi
echo "[+] Installing mate desktop and setting it to default Xsession..."
apt-get -y -qq install mate-core mate-desktop-environment-extra mate-desktop-environment-extras 
echo mate-session > ~/.xsession

echo "[+] Downloading theme and fonts..."
mkdir "$SCRIPTDLPATH" 2>/dev/null
wget -q -P "$SCRIPTDLPATH" http://ftp.iinet.net.au/pub/ubuntu/pool/main/u/ubuntu-themes/ubuntu-mono_16.10+16.10.20160908-0ubuntu1_all.deb
wget -q -P "$SCRIPTDLPATH" http://ftp.iinet.net.au/pub/ubuntu/pool/main/u/ubuntu-themes/ubuntu-themes_16.10+16.10.20160908.orig.tar.gz
wget -q -P "$SCRIPTDLPATH" http://ftp.iinet.net.au/pub/ubuntu/pool/main/h/humanity-icon-theme/humanity-icon-theme_0.6.10_all.deb
wget -q -P "$SCRIPTDLPATH" http://ftp.iinet.net.au/pub/ubuntu/pool/main/u/ubuntu-font-family-sources/ttf-ubuntu-font-family_0.83-0ubuntu2_all.deb

echo "[+] Installing theme and fonts..."
cd "$SCRIPTDLPATH"
dpkg -i humanity-icon*.deb
dpkg -i ubuntu-mono*.deb
dpkg -i ttf-ubuntu-font*deb
tar xf ubuntu-themes*tar.gz
make
cp -r Ambiance /usr/share/themes
cd $OLDPWD
cp themefiles/gtk-main.css /usr/share/themes/Ambiance
cp themefiles/mate-applications.css /usr/share/themes/Ambiance
cp themefiles/kalibg.png ~/Pictures
cp .vimrc ~

echo "[+] Installing more packages..."
apt-get -y -qq install gimp squashfs-tools pngcheck exiftool mongodb-clients sshpass libssl-dev pdfcrack tesseract-ocr zlib1g-dev vagrant strace ltrace

echo "[+] Installing pwntools..."
pip install pwntools

echo "[+] Installing xortool..."
pip install xortool

echo "[+] Installing gmpy..."
pip install gmpy

echo "[+] Installing sympy..."
pip install sympy

echo "[+] Installing Stegosolve..."
wget -O /usr/bin/Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
chmod +x /usr/bin/Stegsolve.jar

echo "[+] Installing highline..."
gem install highline

echo "[+] Installing zipruby..."
gem install zipruby

echo "[+] Cloning some important git repos..."
mkdir gitrepos
git clone https://github.com/BuffaloWill/oxml_xxe
git clone https://github.com/sensepost/anapickle
git clone https://github.com/hellman/libnum
git clone https://github.com/CoreSecurity/impacket

echo "[+] Setting up libnum..."
cd libnum
python setup.py install

echo "[+] Setting up impacket..."
cd ../impacket
python setup.py install

cd ../..

echo "[+] Installing PEDA..."
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

echo "[+] Updating Metasploit..."
msfupdate

echo "[+] Updating wpscan..."
wpscan --update

echo "[+] Updating mate settings..."
# Terminal 
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ scrollback-unlimited true	# unlimited terminal scrollback
gsettings set org.mate.terminal.keybindings help 'disabled' # hate hitting help accidently, noone cares

# Disable screensavers!
gsettings set org.mate.screensaver idle-activation-enabled false	# disable screensave
gsettings set org.mate.power-manager sleep-display-ac 0				# disable screen sleeping when plugged in

# Wallpaper settings
gsettings set org.mate.background picture-options 'centered'		# set wallpaper options
gsettings set org.mate.background picture-filename '/root/Pictures/kalibg.png'
gsettings set org.mate.background color-shading-type 'solid'
gsettings set org.mate.background primary-color '#23231f1f2020'

# Theme and fonts
gsettings set org.mate.interface gtk-theme 'Ambiance'
gsettings set org.mate.interface icon-theme 'ubuntu-mono-dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Ambiance'
gsettings set org.mate.Marco.general theme 'Ambiance'
gsettings set org.mate.font-rendering antialiasing 'rgba'
gsettings set org.mate.font-rendering hinting 'slight'

rm -fr "$SCRIPTDLPATH"
echo "[*] You need to reboot for the vmtools to take effect."
