mod platform;

use std::{
    collections::HashMap,
    fs::File,
    io::{BufRead, BufReader},
    os::unix::fs::symlink,
    path::{Path, PathBuf},
    process::{Command, ExitStatus},
};

use clap::{command, Args, Parser, Subcommand};
use eyre::Result;
use lazy_static::lazy_static;
use yansi::Paint;

lazy_static! {
    static ref ROOT: PathBuf = platform::root_path();
    static ref HOME: PathBuf = platform::home_path();
    static ref LINK_MAP: HashMap<String, LinkInfo> = create_link_map();
}

macro_rules! cmd {
    ($bin:literal, $($args:expr),*) => {
        Command::new($bin).current_dir(ROOT.as_path()).args(&[$($args),*]).spawn()?.wait()?
    };
    ($bin:literal) => {
        Command::new($bin).current_dir(ROOT.as_path()).spawn()?.wait()?
    };
}

// macro_rules! output {
//     ($bin:literal, $($args:expr),*) => {
//         Command::new($bin).current_dir(ROOT.as_path()).args(&[$($args),*]).output()?
//     };
//     ($bin:literal) => {
//         Command::new($bin).current_dir(ROOT.as_path()).output()?
//     };
// }

struct LinkInfo {
    pub name: String,
    pub original: PathBuf,
    pub link: PathBuf,
}

impl LinkInfo {
    fn new(name: &str, original: &str, link: &str) -> Self {
        Self {
            name: name.to_string(),
            original: ROOT.join(original),
            link: HOME.join(link),
        }
    }
}

#[rustfmt::skip]
fn create_link_map() -> HashMap<String, LinkInfo> {
    let mut map = HashMap::with_capacity(8);
    map.insert("alacritty".to_string(), LinkInfo::new("alacritty", "config/.config/alacritty", ".config/alacritty"));
    map.insert("awesome".to_string(), LinkInfo::new("awesome", "config/.config/awesome", ".config/awesome"));
    map.insert("git".to_string(), LinkInfo::new("git", "config/.config/git", ".config/git"));
    map.insert("nushell".to_string(), LinkInfo::new("nushell", "config/.config/nushell", ".config/nushell"));
    map.insert("nvim".to_string(), LinkInfo::new("nvim", "config/.config/nvim", ".config/nvim"));
    map.insert("wezterm".to_string(), LinkInfo::new("wezterm", "config/.config/wezterm", ".config/wezterm"));
    map.insert("zellij".to_string(), LinkInfo::new("zellij", "config/.config/zellij", ".config/zellij"));
    map
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
fn is_wsl() -> bool {
    false
}

fn is_nixos() -> bool {
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

fn create_link(original: &Path, link: &Path) -> Result<()> {
    if link.is_symlink() {
        if let Ok(pointer) = link.read_link() {
            if pointer == original {
                println!(
                    "link {} already links to {}, skipping",
                    link.display(),
                    original.display()
                );
                return Ok(());
            }
        }
    } else if link.is_dir() || link.is_file() {
        println!(
            "target '{}' exists and is not a link. Skipping",
            link.display()
        );
        return Ok(());
    }

    Ok(symlink(original, link)?)
}

fn cached_link_restore() -> Vec<(&'static Path, &'static Path)> {
    let mut cached_link_restore = vec![];
    for value in LINK_MAP.values() {
        if value.link.is_symlink() {
            if let Ok(pointer) = value.link.read_link() {
                if !pointer.starts_with("/nix/store") {}
            }
        }
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

const LINK_AFTER_HELP: &str = "\
 Status is represented by the following colors:
    - Green:  Linked to local 'config/'
    - Cyan:   Linked to the nix store
    - Yellow: Linked to somewhere other then /nix/store
    - Red:    Target points to a non linked directory
    - Blue:   Target does not exist on system
";

/// Create a symlink to config file.
///
/// If no application is given all will be provided.
#[derive(Debug, Args, Default)]
#[command(visible_alias("l"), after_help=LINK_AFTER_HELP)]
struct Link {
    /// Link all targets
    #[arg(short, long, default_value_t = false)]
    all: bool,

    /// List valid targets
    #[arg(short, long, default_value_t = false)]
    list: bool,

    /// Status of targets
    #[arg(short, long, default_value_t = false)]
    status: bool,

    // #[arg(default_value = None)]
    // target: Option<String>,
    #[arg(default_value = None, required_unless_present_any = ["list", "status", "all"])]
    target: Option<String>,
}
impl Run for Link {
    fn run(&self) -> Result<()> {
        if self.status {
            let mut keys = LINK_MAP.keys().collect::<Vec<_>>();
            keys.sort();
            for name in keys {
                let value = LINK_MAP.get(name).expect("key comes from map");
                let (original, link) = (value.original, value.link);
                let (paint, path) = if let Ok(pointer) = link.read_link() {
                    let paint = if pointer == original {
                        Paint::green(*name)
                    } else if pointer.starts_with("/nix/store") {
                        Paint::cyan(*name)
                    } else {
                        Paint::yellow(*name)
                    };
                    (paint, pointer.display().to_string())
                } else if link.exists() {
                    (Paint::red(*name), link.display().to_string())
                } else {
                    (Paint::blue(*name), "---".to_string())
                };

                println!("{:>10} {}", paint, path);
            }
            return Ok(());
        }

        if self.list {
            let mut keys = LINK_MAP.keys().collect::<Vec<_>>();
            keys.sort();

            for l in keys {
                println!("{}", l);
            }
            return Ok(());
        }

        if self.all {
            for value in LINK_MAP.values() {
                create_link(&value.original, &value.link)?;
            }
            return Ok(());
        }

        if let Some(target) = &self.target {
            if let Some(value) = LINK_MAP.get(target.as_str()) {
                return create_link(&value.original, &value.link);
            }
        }

        Ok(())
    }
}

/// Rollback the current generation.
#[derive(Debug, Args, Default)]
#[command()]
struct Rollback {
    /// Relink set links after switch completes
    #[arg(short, long, default_value_t = false)]
    link: bool,

    /// Show what would be applied
    #[arg(short, long, default_value_t = false)]
    dryrun: bool,
}

impl Run for Rollback {
    fn run(&self) -> Result<()> {
        self.rollback()
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
        let args = self.dryrun.then_some("--dry-run").unwrap_or("");
        cmd!("darwin-rebuild", "switch" "--rollback", args);
        Ok(())
    }
}

/// Switch the current installed configuration state.
#[derive(Debug, Args, Default)]
#[command(visible_alias("s"))]
struct Switch {
    /// Relink set links after switch completes
    #[arg(short, long, default_value_t = false)]
    link: bool,

    /// Show what would be applied
    #[arg(short, long, default_value_t = false)]
    dryrun: bool,

    /// Name of nix target to switch to
    #[arg(default_value= None)]
    target: Option<String>,
}

impl Run for Switch {
    fn run(&self) -> Result<()> {
        let mut cached_link_restore = vec![];
        if !self.dryrun {
            for value in LINK_MAP.values() {
                // if the link is a symlink and is not pointing to the nix store, then cache the
                // pointer location for later use
                if value.link.is_symlink() {
                    if let Ok(pointer) = std::fs::read_link(&value.link) {
                        if !pointer.starts_with("/nix/store") {
                            cached_link_restore.push((&value.link, pointer));
                            std::fs::remove_file(&value.link);
                        }
                    }
                }
            }
        }

        // call switch command and check the results to see if it fails
        let exit_status = self.switch()?;
        if !exit_status.success() || self.link {
            for (dest, link) in &cached_link_restore {
                symlink(dest, link)?;
            }
        }

        Ok(())
    }
}

impl Switch {
    #[cfg(target_os = "linux")]
    fn switch(&self) -> Result<ExitStatus> {
        if is_nixos() {
            let flake = self
                .target
                .as_ref()
                .map(|t| format!(".#{}", t))
                .unwrap_or(".".to_string());

            let subcmd = if self.dryrun {
                "dry-activate"
            } else {
                "switch"
            };
            Ok(cmd!("sudo", "nixos-rebuild", subcmd, "--flake", &flake))
        } else {
            let flake = self
                .target
                .as_ref()
                .map(|t| format!(".#top.{}", t))
                .unwrap_or(".".to_string());
            let args = self.dryrun.then_some("--dry-run").unwrap_or("");
            let exit_status = cmd!("nix", "build", &flake, args);
            if !self.dryrun {
                Ok(cmd!("./result/activate"))
            } else {
                Ok(exit_status)
            }
        }
    }

    #[cfg(not(target_os = "linux"))]
    fn switch(&self) -> Result<ExitStatus> {
        let flake = self
            .target
            .as_ref()
            .map(|t| format!(".#{}", t))
            .unwrap_or(".".to_string());
        let args = self.dryrun.then_some("--dry-run").unwrap_or("");
        Ok(cmd!("darwin-rebuild", "switch", "--flake", &flake, &args))
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
    target: Option<String>,
}

impl Run for Unlink {
    fn run(&self) -> Result<()> {
        if let Some(target) = &self.target {
            if let Some(value) = LINK_MAP.get(target.as_str()) {
                return Unlink::unlink(&value);
            }
        }

        for value in LINK_MAP.values() {
            Unlink::unlink(&value)?;
        }

        Ok(())
    }
}

impl Unlink {
    fn unlink(info: &LinkInfo) -> Result<()> {
        if info.link.is_symlink() {
            if let Ok(pointer) = info.link.read_link() {
                if pointer == info.original {
                    println!(
                        "link {} points to nyx config folder, Removing",
                        info.link.display(),
                    );
                    std::fs::remove_file(&info.link)?;
                }
            }
        }
        Ok(())
    }
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    if let Some(command) = cli.command {
        command.run()?;
    }

    Ok(())
}
