if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

check_bg_exists() {
    if [ -e "$BGPATH/kalibg.png" ];
    then
        return 1
    fi

    return 0
}

install_bg() {
    local modname="kalibg installer"
    check_bg_exists
    if [ $? -ne 0 ];
    then
        log "warning" "$modname: kalibg.png already exists, skipping"
        return
    fi

    cp "$THEMEFILES/kalibg.png" $BGPATH
    if [ $? -ne 0 ];
    then
        log "error" "$modname: error copying file to $BGPATH"
        return
    fi

    log "info" "$modname completed successfully"
}