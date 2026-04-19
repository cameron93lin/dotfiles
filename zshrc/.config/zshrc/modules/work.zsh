# Work-specific aliases and functions
# Put company-specific config in work.local.zsh (gitignored)

# Source local work config (hostnames, SSH tunnels, credentials, company tools)
[[ -f "${MODULES_DIR:-${0:A:h}}/work.local.zsh" ]] && source "${MODULES_DIR:-${0:A:h}}/work.local.zsh"
