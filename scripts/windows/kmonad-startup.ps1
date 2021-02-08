$ConfigFile = [IO.Path]::Combine($HOME, ".config", "kmonad", "windows.kbd")

if (Get-Command -Name kmonad -ErrorAction Ignore) {
    kmonad $ConfigFile &
}

