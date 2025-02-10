if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

source $BASEPATH/modules/common.sh

is_in_path() {
  local dir="$1"

  if [[ "$PATH" == "$dir"* ]];
  then
    return 0 # first dir in path
  fi

  if echo "$PATH" | grep -Eq "\b$dir\b"; then
    return 0  # Directory is somewhere in PATH
  else
    return 1  # Directory is not in PATH
  fi
}

add_path() {
  local dir="$1"

  # Check if the directory exists
  if [ ! -d "$dir" ]; then
    log "error" "directory '$dir' does not exist"
    return 1
  fi

  # Check if the directory is already in the PATH
  if is_in_path "$dir"; then
    log "info" "directory '$dir' is already in the PATH, skipping"
    return 0
  fi

  # Add the directory to the PATH in .bashrc
  echo "export PATH=\"$dir:\$PATH\"" >> ~/.bashrc  # Append to .bashrc
  log "info" "'$dir' added to .bashrc. Terminal needs to be restarted to take effect."

  return 0
}

add_paths() {
    add_path "$HOME/.local/bin"
}