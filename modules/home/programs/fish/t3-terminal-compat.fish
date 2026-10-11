# T3 Code can start fish before its terminal answers capability queries.
# Feature flags are read before config files, so restart only T3-owned shells.
if status is-interactive; and status test-feature query-term; and test -r /proc/$fish_pid/status
    set -l parent_pid (string match --regex --groups-only '^PPid:\s+(\d+)' < /proc/$fish_pid/status)
    set -l parent_exe (path basename (path resolve /proc/$parent_pid/exe 2>/dev/null))

    if contains -- "$parent_exe" t3 t3code
        set -l original_command (string split0 < /proc/$fish_pid/cmdline)
        set -l fish_exe (status fish-path)
        set -l login_flag
        if status is-login
            set login_flag --login
        end
        exec $fish_exe $login_flag $original_command[2..-1] --features=no-query-term
    end
end
