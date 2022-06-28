if not ("~/.cache/nushell/modules/zoxide.nu" | path exists) {
    zoxide init nushell --hook prompt | save ~/.cache/nushell/modules/zoxide.nu
}

source ~/.cache/nushell/modules/zoxide.nu
