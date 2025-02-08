if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

check_vimrc_exists() {
    if [ -e "$HOME/.vimrc" ];
    then
        return 1
    fi

    return 0
}

install_vimrc() {
    local modname="vimrc installer"
    check_vimrc_exists
    if [ $? -ne 0 ];
    then
        log "warning" "$modname: ~/.vimrc already exists, skipping"
        return
    fi

    cp "$THEMEFILES/.vimrc" $HOME
    if [ $? -ne 0 ];
    then
        log "error" "$modname error copying vimrc file to $HOME"
        return
    fi

    log "info" "$modname completed successfully"
}