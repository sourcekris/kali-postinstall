if [ "$BASEPATH" == "" ];
then
    echo "BASEPATH not set, this module is not designed to be called directly."
    exit
fi

VERSION="2024.4"

## Paths
# Path to download packages, etc to
SCRIPTDLPATH="$BASEPATH/scriptdls/"
THEMEFILES="$BASEPATH/themefiles/"
BGPATH="/usr/share/backgrounds"

## Preferred Kali mirror. See: https://http.kali.org/README?mirrorlist
#KALIMIRROR="http://mirror.aarnet.edu.au/pub/kali/kali"
KALIMIRROR="https://kali.download/kali/" # Cloudflare

VERBOSE=0

# We do VM detection later, default case it false, set manually to true if the 
# detection fails for you
VM=false

# log pretty prints a log message including a log level and call site.
# Args:
#  - type - oneof info, warning, error
#  - message - the log message to print.
log() {
  local type="$1"
  local message="$2"

  # Get the name of the calling script for more descriptive error cases.
  local callsite="${BASH_SOURCE[1]}"  # Index 1 gets the caller
  callsite="${callsite##*/}"          # Extract filename (remove path)
  modname="${callsite%.*}"            # Calling module base name.

  local width=8
  printf -v modname "%-${width}s" "$modname"

  case "$type" in
    "info")
      prefix="[+]"
      color_code="\033[0;32m" # Green
      ;;
    "warning")
      prefix="[!]"
      color_code="\033[0;33m" # Yellow
      ;;
    "error")
      prefix="[-]"
      color_code="\033[0;31m" # Red
      ;;
    *)
      log "error" "Internal error: invalid log message type specified \"$type\" in $callsite" >&2  # Print error to stderr
      return 1  # Indicate failure
      ;;
  esac

  echo -e "${color_code}${prefix} [$modname] ${message}\033[0m" # Print with color and reset
}

# err prints an error message from a module including the error code if the error code != 0.
# Args:
#  - eror code 
#  - message - the log message to print.
err() {
    local ec="$1"
    local module="$2"
    local task="$3"

    if [ "$ec" != "0" ];
    then
        log "error" "$module failed $task with error code $ec"
    fi
}