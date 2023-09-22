use std::{path::PathBuf, str::FromStr};

pub fn root_path() -> PathBuf {
    if let Ok(path) = std::env::var("NYX_ROOT_PATH").map(PathBuf::from) {
        return path;
    };

    if let Ok(home) = std::env::var("HOME").map(PathBuf::from) {
        return home.join(".local/nyx");
    }

    shellexpand::tilde("~/.local/nyx").into_owned().into()
}

pub fn home_path() -> PathBuf {
    std::env::var("HOME")
        .map(PathBuf::from)
        .unwrap_or(shellexpand::tilde("~").into_owned().into())
}
