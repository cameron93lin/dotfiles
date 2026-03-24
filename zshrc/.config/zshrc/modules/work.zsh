# Work specific aliases and functions
# Sensitive config (hostnames, credentials) goes in work.local.zsh (gitignored)

# Generic build aliases
alias bb="brazil-build"
alias bba="brazil ws clean && brazil-recursive-cmd --allPackages brazil-build"
alias bbc="brazil ws clean"
alias midway="kinit -f && mwinit -o"
alias sam="brazil-build-tool-exec sam package&&brazil-build-tool-exec sam deploy"
alias cdkbbc="bbc&&bb&&cdkdeploy"
alias cdkbb="bb&&cdkdeploy"

# CDK helpers
function cdkls(){
    array_of_lines=("${(@f)$(bb cdk list)}")
}

function listcdk(){
    for (( i=0; i<${#array_of_lines[@]}; i++ )); do echo ${array_of_lines[i]}; done
    echo
    printf "%s\n" "${array_of_lines[@]}"
}

# Cert management helpers
ki() {
    kinit -f && date +%s > ~/.kinit_ts
}

check_kinit() {
    local TS KIN KDIFF
    TS=$(date +%s)
    read -r KIN < ~/.kinit_ts 2>/dev/null || KIN=0
    [[ "$KIN" =~ ^[0-9]+$ ]] || KIN=0
    KDIFF=$((TS - KIN))
    if (( KDIFF > 21600 )); then
        echo "KINIT expired, renewing cert..."
        ki
    fi
}

mw() {
    local PIN OTP
    PIN=$(security find-generic-password \
        -a "$USER" \
        -s "mwinit-pin" \
        -w) || {
        echo "Failed to retrieve PIN from Keychain"
        return 1
    }
    read "OTP?Yubikey: "
    if mwinit -o <<EOF
$PIN
$OTP
EOF
    then
        date +%s > ~/.mwinit_ts
    else
        echo "mwinit failed; not updating timestamp"
        return 1
    fi
    unset PIN OTP
}

check_mwinit() {
    local TS MWIN MWDIFF
    TS=$(date +%s)
    read -r MWIN < ~/.mwinit_ts 2>/dev/null || MWIN=0
    [[ "$MWIN" =~ ^[0-9]+$ ]] || MWIN=0
    MWDIFF=$((TS - MWIN))
    if (( MWDIFF > 43200 )); then
        echo "MWINIT expired, renewing sign..."
        mw
    fi
}

_check_inits() {
    check_kinit
    check_mwinit
}
# Auto check on load (disabled)
# _check_inits

ut() {
    eval `ssh-agent -s`
    ssh-add ~/.ssh/id_rsa
    ki
    mw
}

# Source local work config (hostnames, SSH tunnels, stack names)
[[ -f "${MODULES_DIR:-${0:A:h}}/work.local.zsh" ]] && source "${MODULES_DIR:-${0:A:h}}/work.local.zsh"
