# NOTE: apt function library. <skr 2022-07>

function make_keyring() {
  : ${file:?} ${url:?}

  declare -Ag keyring=(
    [url]="$url"
    [file]="$file"
  )
}

# CAVEAT: Assumes one-and-only-one component. <skr 2022-07>
function make_list() {
  [[ -n ${keyring[file]:+nonempty} ]] || return 1

  : ${arch:?} ${component:?} ${distribution:?} ${file:?} ${url:?}

  local entry="deb [arch=$arch signed-by=$signed_by] $url $distribution $component"

  declare -Ag list=(
    [arch]="$arch"
    [distribution]="$distribution"
    [component]="$component"
    [file]="$file"
    [entry]="$entry"
    [url]="$url"
    [signed-by]="${keyring[file]}"
  )
}

function download_keyring() {
  ([[ -n ${keyring[file]:+nonempty} ]] && [[ -n ${keyring[url]:+nonempty} ]]) ||  return 1
 
  curl --fail --location --silent --show-error "${keyring[url]}" | \
  sudo gpg --no-default-keyring --keyring "${keyring[file]}" --import -
}

function install_list() {
  ([[ -n ${list[entry]:+nonempty} ]] && [[ -n ${list[file]:+nonempty} ]]) ||  return 1

  sudo bash -c "echo ${list[entry]@Q} > ${list[file]@Q}"
}

function update_lists() {
  sudo apt-get update
}

function install_packages() {
  [[ $# -ge 1 ]] || return 1

  sudo apt-get install --assume-yes -- "$@"
}
