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

apt_update() {
    local modname="apt updater"
    log "info" "running apt updater"
    apt update 2>&1 | awk '{printf "%s%s\n", "    ", $0}'
    echo
}

apt_upgrade() {
    local modname="apt upgrade"
    apt_update
    apt upgrade -y
}

apt_cleanup() {
    local modname="apt cleanup"
    apt autoremove -y
}

# apt_mirror_exists checks if the URL is already the specified mirror.
# Args:
#   - mirror_url
# Returns:
#   - 0 if it does exists already or an error occured
#   - 1 if it doesnt exist
apt_mirror_exists() {
    local mirror_url="$1"
    if [ -z "$mirror_url" ]; then
        log "error" "apt mirror url not specified"
        return 0
    fi

    local mirror_line="deb \"$mirror_url\" kali-rolling"

    if grep -q "$mirror_line" /etc/apt/sources.list; 
    then
        # return 0, it exists
        return 0
    fi

    return 1
}

# apt_kali_mirror_change takes a URL as the argument and replaces the kali linux source.
apt_kali_mirror_change() {
    local modname="apt mirror change"
    local mirror_url="$1"

    if [ -z "$mirror_url" ]; then
        log "error" "$modname: apt mirror url not specified"
        return 1 
    fi

    if apt_mirror_exists "$mirror_url";
    then
        log "warning" "$modname: mirror is already updated, skipping"
        return 1
    fi

    # Backup the current sources.list file
    cp /etc/apt/sources.list /etc/apt/sources.list.bak

    # Construct the new sources.list content
    new_sources_list=$(cat <<EOF
deb "$mirror_url" kali-rolling main contrib non-free non-free-firmware
# For source code
# deb-src "$mirror_url" kali-rolling main contrib non-free non-free-firmware
EOF
)
    # Overwrite the sources.list
    echo "$new_sources_list" > /etc/apt/sources.list

    apt_update

    log "info" "$modname succeeded, new mirror: $mirror_url"
    return 0 # Indicate success
}