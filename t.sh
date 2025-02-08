#!/bin/bash

# Script testing common modules.

BASEPATH=`pwd`

source $BASEPATH/modules/common.sh
source $BASEPATH/modules/font.sh
source $BASEPATH/modules/vimrc.sh
source $BASEPATH/modules/kalibg.sh
source $BASEPATH/modules/chsh.sh
source $BASEPATH/modules/vscode.sh

# log "info" "Starting the process..."
# log "warning" "Disk space is running low."
# log "error" "Failed to connect to the server."
# log "invalid" "This is an invalid type." 

install_font
install_vimrc
install_bg
change_shell_to_bash
install_vscode
