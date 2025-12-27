ssh-add --apple-use-keychain ~/.ssh/pnegus_gh
# Added by Antigravity
export PATH="/Users/pnegus/.antigravity/antigravity/bin:$PATH"

function chrome-sniff() {
    mkdir -p /tmp/tmp-google
    SSLKEYLOGFILE=/tmp/tmp-google/.ssl-key.log \
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --user-data-dir=/tmp/tmp-google \
    "$@"
}

export PATH="$HOME/.docker/bin:$PATH"
export PATH="/usr/local/aws-cli:$PATH"