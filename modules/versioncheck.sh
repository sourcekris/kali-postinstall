if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

version_check() {
    local distro=$(lsb_release -is)
    local release=$(lsb_release -rs)

    if [ "$distro" != "Kali" ];
    then
        log "error" "Linux distribution is $distro $release, expected Kali $VERSION"
        return 1
    fi

    if [ "$release" != "$VERSION" ];
    then
        log "error" "This is for Kali $VERSION but found $distro $release"
        return 1
    fi

    log "info" "Running on $distro $release, continuing"
    return 0
}