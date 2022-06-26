# let local-env-path  = ([$nu.home-path .local share nushell login-env.nu] | path join)
# if ($local-env-path | path exists) {
#     print "sourcing $local-env-path"
#     source ~/.local/share/nushell/login-env.nu
# }
source ~/.local/share/nushell/login-env.nu

mkdir ~/.cache/nu/modules
starship init nu | save ~/.cache/nu/modules/starship.nu
zoxide init nushell --hook prompt | save ~/.cache/nu/modules/zoxide.nu
