# see https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    hooks: {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {
            PWD: [
                {
                    # https://github.com/direnv/direnv
                    condition: { || __dotfiles_has_executable 'direnv' },
                    code: { || ^direnv export json | from json | default {} | load-env },
                },
            ],
        },
        display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }
}

source ("~/.config/nushell/aliases.nu" | path expand)
source ("~/.config/nushell/interactive.nu" | path expand)
