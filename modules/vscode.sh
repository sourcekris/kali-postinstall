if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

check_vscode_exists() {
    dpkg -s code > /dev/null 2>&1
    return $?
}

install_vscode() {
    local modname="VSCode installer"
    local fileurl="https://go.microsoft.com/fwlink/?LinkID=760868"
    
    check_vscode_exists
    if [ $? -eq 0 ];
    then
        log "warning" "$modname: already installed, skipping"
        return
    fi

    mkdir -p "$SCRIPTDLPATH" 2>/dev/null    # Its fine it this already exists.

    log "info" "Downloading $modname..."
    wget -qO "$SCRIPTDLPATH/code.deb" "$fileurl"
    if [ $? != 0 ];
    then
        log "error" "$modname failed downloading file: $?"
        return
    fi

    log "info" "Installing $modname"
    cd "$SCRIPTDLPATH"
    dpkg -i code.deb
    if [ $? != 0 ];
    then
        log "error" "$modname failed installing: $?"
        return
    fi

    log "info" "$modname completed successfully."
}