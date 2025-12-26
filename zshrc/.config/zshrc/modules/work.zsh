# Work specific aliases and functions

# Aliases
alias odin="ssh -f -N -L 2009:localhost:2009 dev-dsk-chenyif-2b-fe113faf.us-west-2.amazon.com"
alias midway="kinit -f && mwinit -o"
alias bb="brazil-build"
alias bba="brazil ws clean && brazil-recursive-cmd --allPackages brazil-build"
alias bbc="brazil ws clean"
alias sam="brazil-build-tool-exec sam package&&brazil-build-tool-exec sam deploy"
alias cdkbbc="bbc&&bb&&cdkdeploy"
alias cdkbb="bb&&cdkdeploy"
alias scalatest="bba&&bb deploy:assets AlexaDexterCDMonitorCodeStack-dev-chenyif&&bb cdk deploy AlexaDexterCDMonitorCodeStack-dev-chenyif"
alias cdcoral="ssh chenyif@devDesktop -N -L 8280:127.0.0.1:8280 -L 8243:127.0.0.1:8243&"
alias opencoral="open http://dev-dsk-chenyif-2b-fe113faf.us-west-2.amazon.com/explorer/index.html#"
alias opencd="python3 ~/Downloads/dcv-cdd.py connect dev-dsk-chenyif-2b-fe113faf.us-west-2.amazon.com"

# Exports
export CDK_STACKNAME="Siren-EsIngestor-Stack-chenyif"
export CDK_REGION="eu-central-1"

# Functions
function cdkdeploy() {
    if [ $# -eq 0 ]; then 
        aws cloudformation update-termination-protection --stack-name $CDK_STACKNAME --no-enable-termination-protection --region $CDK_REGION
        bb cdk deploy $CDK_STACKNAME 
    fi
    if [ $# -eq 1 ]; then 
        aws cloudformation update-termination-protection --stack-name "Siren-$1-Stack-chenyif" --no-enable-termination-protection --region $CDK_REGION
        bb cdk deploy "Siren-$1-Stack-chenyif"
    fi
    if [ $# -eq 2 ]; then 
        aws cloudformation update-termination-protection --stack-name "Siren-$1-Stack-chenyif" --no-enable-termination-protection --region $2
        bb cdk deploy "Siren-$1-Stack-chenyif" 
    fi
}

function cdkls(){
    array_of_lines=("${(@f)$(bb cdk list)}")
}

function listcdk(){
    for (( i=0; i<${#array_of_lines[@]}; i++ )); do echo ${array_of_lines[i]}; done
    echo
    printf "%s\n" "${array_of_lines[@]}"
}

ki() {
    kinit -f && date +%s > ~/.kinit_ts
}
 
check_kinit() {
    local TS KIN KDIFF
    TS=$(date +%s)

    read -r KIN < ~/.kinit_ts || KIN=0
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

    read -r MWIN < ~/.mwinit_ts || MWIN=0
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
# Auto check on load
_check_inits
 
ut() {
    eval `ssh-agent -s`
    ssh-add ~/.ssh/id_rsa
    ki
    mw
}
