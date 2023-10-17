source ('~/.config/nushell/init.nu' | path expand)

# Checks it starship is installed if installed then write cache
# This works because env.nu is called before config. Sourcing is
# done in config.nu


mkdir ('~/.cache/nushell/modules' | path expand)
if (__dotfiles_has_executable 'starship') {
    let starship_path = ('~/.cache/nushell/modules/starship.nu' | path expand)
    if not ($starship_path | path exists) {
        starship init nu | save -f $starship_path
    }
}

if (__dotfiles_has_executable 'zoxide') {
    let zoxide_path = ('~/.cache/nushell/modules/zoxide.nu' | path expand)
    if not ($zoxide_path | path exists) {
        zoxide init nushell | save -f $zoxide_path
    }
}

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]
