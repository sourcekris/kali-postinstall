if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

check_already_bash() {
    local roots_shell=$(getent passwd root | awk -F: '{print $7}')
    if [ "$roots_shell" == "/bin/bash" ];
    then
        return 1
    fi

    return 0
}

change_shell_to_bash() {
    local modname="shell changer"
    check_already_bash
    if [ $? -ne 0 ];
    then
        log "warning" "$modname: shell is already bash, skipping"
        return
    fi

    chsh -s /bin/bash root
    if [ $? -ne 0 ];
    then
        log "error" "$modname error changing shell"
        return
    fi

    log "info" "$modname completed successfully"
}