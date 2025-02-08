if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

# check_font_exists returns 0 if the Ubuntu font is not installed.
check_font_exists() {
    local ufont=1
    local umonofont=1

    fc-list -q Ubuntu
    if [ $? -eq 0 ];
    then
        ufont=0
    fi

    fc-list -q "Ubuntu Mono"
    if [ $? -eq 0 ];
    then
        umonofont=0
    fi

    if [[ "$ufont" -eq 0 && "$umonofont" -eq 0 ]];
    then
        return 1
    fi

    return 0
}

install_font() {
    local modname="Ubuntu font installer"
    local fonturl="https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip"
    check_font_exists
    if [ $? -eq 1 ];
    then
        log "warning" "$modname: font already installed, skipping"
        return
    fi

    mkdir -p "$SCRIPTDLPATH" 2>/dev/null    # Its fine it this already exists.

    log "info" "Downloading ubuntu font..."
    wget -qO "$SCRIPTDLPATH/font.zip" "$fonturl"
    if [ $? != 0 ];
    then
        log "error" "$modname failed downloading font: $?"
        return
    fi

    log "info" "Installing font"
    cd "$SCRIPTDLPATH"
    unzip -qq -o -d /usr/share/fonts/truetype/ttf-ubuntu font.zip
    if [ $? != 0 ];
    then
        log "error" "$modname failed unzipping font: $?"
        return
    fi

    fc-cache -f
    if [ $? != 0 ];
    then
        log "error" "$modname failed updating font cache: $?"
        return
    fi

    log "info" "$modname completed successfully."
    return
}