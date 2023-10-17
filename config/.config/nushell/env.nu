# # Check if a command is installed in path
# def is-installed [app: string] {
#     ((which $app | length) > 0)
# }
#
# def prepend-path [path: string] {
#     $env.PATH = ($env.PATH | split row (char esep) | prepend $path)
# }
#
# def append-path [path: string] {
#     $env.PATH = ($env.PATH | split row (char esep) | append $path)
# }
#
# # Specifies how environment variables are:
# # - converted from a string to a value on Nushell startup (from_string)
# # - converted from a value back to a string when running external commands (to_string)
# # Note: The conversions happen *after* config.nu is loaded
# $env.ENV_CONVERSIONS = {
#     "PATH": {
#         from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
#         to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
#     }
#     "Path": {
#         from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
#         to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
#     }
# }
#
# # Directories to search for scripts when calling source or use
# $env.NU_LIB_DIRS = [
#     # FIXME: This default is not implemented in rust code as of 2023-09-06.
#     ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
# ]
#
# # Directories to search for plugin binaries when calling register
# $env.NU_PLUGIN_DIRS = [
#     # FIXME: This default is not implemented in rust code as of 2023-09-06.
#     ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
# ]
#
# # To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# # $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
#
# const nyx_env_path = "~/.local/share/nushell/nyx-env.nu"
# const if ($nyx_env_path | path expand | path exists) {
#     sourse $nyx_env_path
# }
#
# const local_env_path = "~/.local/share/nushell/env.nu"
# const if ($local_env_path | path expand | path exists) {
#     sourse $local_env_path
# }
