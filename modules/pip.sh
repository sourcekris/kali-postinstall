if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh
source $BASEPATH/modules/apt.sh

pip_install_packages() {
    # pip / pip3 is not supported on Kali, pipx is the recommended way
    # See: https://www.kali.org/docs/general-use/python3-external-packages/
    apt_package_exists "pipx"
    if [ $? -ne 0 ];
    then
        log "error" "pipx is not installed, but is required by Kali $VERSION to install python packages"
        return 1
    fi

    log "info" "installing python packages..."
    pipx install pwntools xortool sympy pycryptodome 2>&1 | awk '{printf "%s%s\n", "    ", $0}'
    log "info" "completed python package installation."
}