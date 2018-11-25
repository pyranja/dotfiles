#!/bin/bash
set -o errexit
set -o nounset

YADM_VERSION='1.12.0'
YADM_CHECKSUM='5d1fb19a0a10679908df8cf1864659aedd7ff699c4a6178cf1a7c65cec569f44'
YADM_COMMAND='yadm'

function progress () { echo -e " \\033[1;34m➜\\033[0m  $*"; }
function success ()  { echo -e " \\033[1;32m✔\\033[0m  $*"; }

# ensure prerequisites present
progress "installing prerequisites"
sudo add-apt-repository --yes ppa:git-core/ppa \
    && sudo apt-get -qq update \
    && sudo apt-get -qq install curl git

# download and verify yadm
source="https://raw.githubusercontent.com/TheLocehiliosan/yadm/$YADM_VERSION/yadm"
stash="/tmp/yadm.$RANDOM"
progress "fetching $source"
progress "stashing as $stash"
curl --create-dirs --fail --show-error --silent --output "$stash" --url "$source"
echo "$YADM_CHECKSUM  $stash" | sha256sum --strict --check --quiet

# install to local path
local_bin="/home/$USER/.local/bin"
executable="$local_bin/$YADM_COMMAND"
progress "installing in $local_bin"
mkdir -p "$local_bin" && mv "$stash" "$executable" && chmod u+x "$executable"
# ensure yadm is present on path for this session
export PATH="$local_bin:$PATH"

success "installed $(yadm version)"
