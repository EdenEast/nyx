def __dotfiles_find_up [filename: string, dir] {
    let candidate = ($dir | path join $filename)
    let parent_dir = ($dir | path dirname)
    if ($candidate | path exists) {
        $candidate
    } else if ($parent_dir != '/') and ($parent_dir | path exists) {
        __dotfiles_find_up $filename $parent_dir
    } else {
        null
    }
}

def __dotfiles_has_executable [KEY: string] {
    not (which $KEY | is-empty)
}

def __dotfiles_has_variable [KEY: string] {
    $env | columns | any { |it| $it == $KEY }
}

def __prepend_path [path: string] {
    $env.PATH = ($env.PATH | split row (char esep) | prepend ($path | path expand))
}

def __append_path [path: string] {
    $env.PATH = ($env.PATH | split row (char esep) | append ($path | path expand))
}


