if not ("~/.cache/nushell/modules/starship.nu" | path exists) {
    starship init nu | save ~/.cache/nushell/modules/starship.nu
}

source ~/.cache/nushell/modules/starship.nu
