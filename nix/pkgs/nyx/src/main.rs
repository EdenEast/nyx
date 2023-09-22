mod platform;

use std::{
    fs::File,
    io::{BufRead, BufReader},
    path::{Path, PathBuf},
    process::Command,
};

use clap::{command, Args, Parser, Subcommand};
use eyre::Result;
use lazy_static::lazy_static;
use phf::phf_map;

lazy_static! {
    static ref ROOT: PathBuf = platform::root_path();
    static ref HOME: PathBuf = platform::home_path();
}

static LINKS: phf::Map<&'static str, (&'static str, &'static str)> = phf_map! {
    "alacritty" => (".config/alacritty", "config/.config/alacritty"),
    "awesome" => (".config/awesome", "config/.config/awesome"),
    "git" => (".config/git", "config/.config/git"),
    "nushell" => (".config/nushell", "config/.config/nushell"),
    "nvim" => (".config/nvim", "config/.config/nvim"),
    "wezterm" => (".config/wezterm", "config/.config/wezterm"),
    "zellij" => (".config/zellij", "config/.config/zellij"),
};

macro_rules! cmd {
    ($bin:literal, $($args:expr),*) => {
        Command::new($bin).current_dir(ROOT.as_path()).args(&[$($args),*]).spawn()?.wait()?
    };
    ($bin:literal) => {
        Command::new($bin).current_dir(ROOT.as_path()).spawn()?.wait()?
    };
}

macro_rules! output {
    ($bin:literal, $($args:expr),*) => {
        Command::new($bin).current_dir(ROOT.as_path()).args(&[$($args),*]).output()?
    };
    ($bin:literal) => {
        Command::new($bin).current_dir(ROOT.as_path()).output()?
    };
}

/// Test if the program is running under WSL
#[cfg(target_os = "linux")]
pub fn is_wsl() -> bool {
    if let Ok(b) = std::fs::read("/proc/sys/kernel/osrelease") {
        if let Ok(s) = std::str::from_utf8(&b) {
            let a = s.to_ascii_lowercase();
            return a.contains("microsoft") || a.contains("wsl");
        }
    }
    false
}

/// Test if the program is running under WSL
#[cfg(not(target_os = "linux"))]
pub fn is_wsl() -> bool {
    false
}

pub fn is_nixos() -> bool {
    // taken from: https://github.com/rust-lang/rust/blob/42f5828b01817e2aa67458c0c50db0b1c240f0bd/src/bootstrap/download.rs#L100-L107
    // Use `/etc/os-release` instead of `/etc/NIXOS`.
    // The latter one does not exist on NixOS when using tmpfs as root.
    match File::open("/etc/os-release") {
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => false,
        Err(e) => panic!("failed to access /etc/os-release: {}", e),
        Ok(os_release) => BufReader::new(os_release).lines().any(|l| {
            let l = l.expect("reading /etc/os-release");
            matches!(l.trim(), "ID=nixos" | "ID='nixos'" | "ID=\"nixos\"")
        }),
    }
}

trait Run {
    fn run(&self) -> Result<()>;
}

#[derive(Debug, Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    pub command: Option<Cmd>,
}

#[derive(Debug, Subcommand)]
enum Cmd {
    Build(Build),
    Gc(Gc),
    Link(Link),
    Rollback(Rollback),
    Switch(Switch),
    Test(Test),
    Unlink(Unlink),
}

impl Run for Cmd {
    fn run(&self) -> Result<()> {
        match self {
            Cmd::Build(x) => x.run(),
            Cmd::Gc(x) => x.run(),
            Cmd::Link(x) => x.run(),
            Cmd::Rollback(x) => x.run(),
            Cmd::Switch(x) => x.run(),
            Cmd::Test(x) => x.run(),
            Cmd::Unlink(x) => x.run(),
        }
    }
}

/// Build an output target.
///
/// If no output target is specified nyx will build either the nixos system
/// configuration or the toplevel host config.
#[derive(Debug, Args, Default)]
#[command(visible_alias("b"))]
struct Build {
    target: Option<String>,
}

impl Build {
    #[cfg(target_os = "linux")]
    fn build(&self) -> Result<()> {
        if is_nixos() {
            cmd!("sudo", "nixos-rebuild", "build", "--flake", ".");
        } else {
            let user = std::env::var("USRR").expect("$USER is defined");
            cmd!("nix", "build", &format!("\".#top.{}\"", user));
        }

        Ok(())
    }

    #[cfg(not(target_os = "linux"))]
    fn build(&self) -> Result<()> {
        cmd!("darwin-rebuild", "build", "--flake", ".");
        Ok(())
    }
}

impl Run for Build {
    fn run(&self) -> Result<()> {
        if let Some(target) = &self.target {
            cmd!("nix", "build", &format!(".#top.{}", target));
        } else {
            self.build()?
        }
        Ok(())
    }
}

/// Garbage collection and nix store optimization
#[derive(Debug, Args, Default)]
#[command()]
struct Gc {
    all: bool,
    system: bool,
}

impl Run for Gc {
    fn run(&self) -> Result<()> {
        cmd!("nix-collect-garbage");
        Ok(())
    }
}

/// Create a symlink to config file.
///
/// If no application is given all will be provided.
#[derive(Debug, Args, Default)]
#[command(visible_alias("l"))]
struct Link {
    /// List valid targets
    #[arg(short, long, default_value_t = false)]
    list: bool,

    /// Status of targets
    #[arg(short, long, default_value_t = false)]
    status: bool,

    #[arg(default_value = None)]
    target: Option<String>,
}
impl Run for Link {
    fn run(&self) -> Result<()> {
        if self.status {
            let mut keys = LINKS.keys().collect::<Vec<_>>();
            keys.sort();

            for k in keys {
                let value = LINKS.get(k).expect("key comes from map");
                let target = HOME.join(value.0);
                let dest = HOME.join(value.1);
            }
        }

        if self.list {
            let mut keys = LINKS.keys().collect::<Vec<_>>();
            keys.sort();

            for l in keys {
                println!("{}", l);
            }
            return Ok(());
        }
        todo!()
    }
}

/// Rollback the current generation.
#[derive(Debug, Args, Default)]
#[command()]
struct Rollback {}

impl Run for Rollback {
    fn run(&self) -> Result<()> {
        todo!()
    }
}

impl Rollback {
    #[cfg(target_os = "linux")]
    fn rollback(&self) -> Result<()> {
        if is_nixos() {
            cmd!("sudo", "nixos-rebuild", "--rollback");
        } else {
        }
        Ok(())
    }
    #[cfg(not(target_os = "linux"))]
    fn rollback(&self) -> Result<()> {
        cmd!("sudo", "darwin-rebuild", "--rollback");
        Ok(())
    }
}

/// Switch the current installed configuration state.
#[derive(Debug, Args, Default)]
#[command(visible_alias("s"))]
struct Switch {
    link: bool,
    target: Option<String>,
}

impl Run for Switch {
    fn run(&self) -> Result<()> {
        todo!()
    }
}

/// Test the current installed configuration state.
#[derive(Debug, Args, Default)]
#[command(visible_alias("t"))]
struct Test {
    link: bool,
    target: Option<String>,
}

impl Run for Test {
    fn run(&self) -> Result<()> {
        todo!()
    }
}

/// Remove manual symlinks to config/ folder
#[derive(Debug, Args, Default)]
#[command(visible_alias("u"))]
struct Unlink {
    list: bool,
    target: Option<String>,
}

impl Run for Unlink {
    fn run(&self) -> Result<()> {
        todo!()
    }
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    if let Some(command) = cli.command {
        command.run()?;
    }

    Ok(())
}
