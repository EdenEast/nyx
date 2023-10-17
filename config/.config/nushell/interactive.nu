$env.LESS = "-C -M -I -j 10 -x 2 -# 4 -R"
if (__dotfiles_has_executable bat) {
    {
        MANPAGER: "bat --language man --decorations=never",
        PAGER: 'bat --decorations=never',
    }
} else {
    {
        MANPAGER: 'less',
        PAGER: 'less',
    }
} | load-env


if $nu.is-interactive {
    if (__dotfiles_has_executable 'starship') {
        source ("~/.cache/nushell/modules/starship.nu" | path expand)
    }
    if (__dotfiles_has_executable 'zoxide') {
        source ("~/.cache/nushell/modules/zoxide.nu" | path expand)
    }
}
