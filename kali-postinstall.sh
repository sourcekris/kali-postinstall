#!/bin/bash
#-Metadata-----------------------------------------------------------------
# Filename: kali-postinstall.sh
# Date: 2018-05-19
# Version: 2018.2
#-Notes--------------------------------------------------------------------
# These are the things I do after install Kali 2018.2 on a new VM/System. 
#
# Run this as root after an install of Kali 2018.2
# 
# This is provided as-is and is not meant for others. However, you might 
# find some of this stuff useful. Got some of these ideas from g0tm1lk,
# see his script at:
#
# https://github.com/g0tmi1k/os-scripts/blob/master/kali.sh
#
# Tweet @CTFKris for ideas to add to this.
#

VERSION="2018.2"

# Path to download packages, XPI's etc to
SCRIPTDLPATH="scriptdls/"

# Kali mirror you prefer, Australians can use AARNet or Internode
KALIMIRROR="ftp\.iinet\.net\.au\/pub"

# We do VM detection later, default case it false, set manually to true if the 
# detection fails for you
VM=false

# Terminal Palette
TERMPAL="#000000000000:#CDCB00000000:#0000CDCB0000:#CDCBCDCB0000:#1E1A908FFFFF:#CDCB0000CDCB:#0000CDCBCDCB:#E5E2E5E2E5E2:#4CCC4CCC4CCC:#FFFF00000000:#0000FFFF0000:#FFFFFFFF0000:#46458281B4AE:#FFFF0000FFFF:#0000FFFFFFFF:#FFFFFFFFFFFF"
TERMBG="#000000000000"
TERMFG="#FFFFFFFFDDDD"

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
	VM=true
fi

echo "[+] Setting preferred Kali mirror - $KALIMIRROR ..."
sed -i "s/http\.kali\.org/$KALIMIRROR/" /etc/apt/sources.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list

echo "[+] Updating repos from new mirror..."
apt-get -qq update

if [ "$VM" == "true" ]
then
	echo "[+] Installing open-vm-tools..."
	apt-get -y -qq install open-vm-tools-desktop fuse 
else
	echo "[*] Virtual machine NOT detected, skipping vmtools installation..."
fi
echo "[+] Installing mate desktop and theme pre-reqs..."
apt-get -y -qq install mate-core mate-desktop-environment-extra mate-desktop-environment-extras autoconf automake pkg-config libgtk-3-dev gnome-themes-standard gtk2-engines-murrine sublime-text

echo "[+] Downloading themes, icons and fonts..."
mkdir "$SCRIPTDLPATH" 2>/dev/null
wget -qO "$SCRIPTDLPATH/font.zip" https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
wget -qO "$SCRIPTDLPATH/icons.deb" http://ftp.iinet.net.au/pub/ubuntu/pool/main/h/humanity-icon-theme/humanity-icon-theme_0.6.15_all.deb
git clone -q https://github.com/horst3180/arc-theme --depth 1 "$SCRIPTDLPATH/arc-theme"

echo "[+] Installing theme, icons and fonts..."
cd "$SCRIPTDLPATH"
dpkg -i icons.deb
unzip -qq -d /usr/share/fonts/truetype/ttf-ubuntu font.zip
fc-cache -f

## Build and install arc-theme
cd arc-theme
./autogen.sh --prefix=/usr --with-gnome-version=3.22
make install

cd ../..
cp themefiles/kalibg.png /usr/share/backgrounds
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
wget -qO /usr/bin/Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
chmod +x /usr/bin/Stegsolve.jar

echo "[+] Installing highline..."
gem install --silent highline

echo "[+] Installing zipruby..."
gem install --silent zipruby

echo "[+] Cloning some important git repos..."
mkdir gitrepos
git clone -q https://github.com/BuffaloWill/oxml_xxe
git clone -q https://github.com/sensepost/anapickle
git clone -q https://github.com/hellman/libnum
git clone -q https://github.com/CoreSecurity/impacket

echo "[+] Setting up libnum..."
cd libnum
python setup.py install

echo "[+] Setting up impacket..."
cd ../impacket
python setup.py install

cd ../..

echo "[+] Installing PEDA..."
git clone -q https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

echo "[+] Updating Metasploit..."
apt-get -y -qq install metasploit-framework

echo "[+] Updating wpscan..."
wpscan --update

echo "[+] Updating mate settings..."
# Terminal 
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ scrollback-unlimited true	# unlimited terminal scrollback
gsettings set org.mate.terminal.keybindings help 'disabled' # hate hitting help accidently, noone cares
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ background-color $TERMBG
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ foreground-color $TERMFG
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ palette $TERMPAL

gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ use-theme-colors false
gsettings set org.mate.terminal.profile:/org/mate/terminal/profiles/default/ bold-color-same-as-fg false

# Disable screensavers!
gsettings set org.mate.screensaver idle-activation-enabled false	# disable screensave
gsettings set org.mate.power-manager sleep-display-ac 0				# disable screen sleeping when plugged in

# Wallpaper settings
gsettings set org.mate.background picture-options 'centered'		# set wallpaper options
gsettings set org.mate.background picture-filename '/usr/share/backgrounds/kalibg.png'
gsettings set org.mate.background color-shading-type 'solid'
gsettings set org.mate.background primary-color '#23231f1f2020'

# Theme and fonts
gsettings set org.mate.interface gtk-theme 'Arc-Dark'
gsettings set org.mate.interface icon-theme 'Humanity-Dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Dark'
gsettings set org.mate.Marco.general theme 'Arc-Dark'
gsettings set org.mate.font-rendering antialiasing 'rgba'
gsettings set org.mate.font-rendering hinting 'slight'
gsettings set org.mate.Marco.general titlebar-font 'Ubuntu Medium 11'
gsettings set org.mate.interface monospace-font-name 'Ubuntu Mono 13'
gsettings set org.mate.interface font-name 'Ubuntu 11'
gsettings set org.mate.caja.desktop font 'Ubuntu 11'

echo "[+] Upgrading all packages..."
apt-get -y upgrade

rm -fr "$SCRIPTDLPATH"
echo "[*] You need to reboot for the theme, MATE Xsession, and VM tools to fully take effect."
printf "[*] Before logging in, click the gear (\\u2699 ) icon on the password prompt and select MATE\n"
