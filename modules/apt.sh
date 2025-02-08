if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

install_apt_packages() {
    local modname="apt package installer"
    apt install -y ghidra remmina python3 evil-ssdp gimp squashfs-tools pngcheck exiftool sshpass libssl-dev pdfcrack tesseract-ocr zlib1g-dev vagrant strace ltrace
}