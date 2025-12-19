#
.DESCRIPTION
    Install chocolatey if exists
#>

function Install-Winget () {
    $progressPreference = 'silentlyContinue'
    $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
    $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
    Write-Information "Downloading winget to artifacts directory..."
    Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage $latestWingetMsixBundle
}

function Install-Choco () {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Check if 'choco' is installed
if ((Get-Command "winget" -ErrorAction SilentlyContinue) -eq $null) {
    Install-Winget
}

# Check if 'choco' is installed
if ((Get-Command "choco.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Install-Choco
}

winget install --no-upgrade --id 7zip.7zip
winget install --no-upgrade --id AutoHotkey.AutoHotkey
winget install --no-upgrade --id Brave.Brave
winget install --no-upgrade --id Casey.Just
winget install --no-upgrade --id Discord.Discord
winget install --no-upgrade --id voidtools.Everything
winget install --no-upgrade --id Mozilla.Firefox
winget install --no-upgrade --id flux.flux
winget install --no-upgrade --id Git.Git
# winget install --no-upgrade --id GnuPG.GnuPG
winget install --no-upgrade --id GnuPG.Gpg4win
winget install --no-upgrade --id OBSProject.OBSStudio
winget install --no-upgrade --id OpenStenoProject.Plover
winget install --no-upgrade --id Spotify.Spotify
winget install --no-upgrade --id Valve.Steam
winget install --no-upgrade --id Ultimaker.Cura
winget install --no-upgrade --id WinDirStat.WinDirStat
winget install --no-upgrade --id Neovim.Neovim.Nightly
winget install --no-upgrade --id Nushell.Nushell
winget install --no-upgrade --id wez.wezterm
winget install --no-upgrade --id Microsoft.PowerToys
winget install --no-upgrade --id Keybase.Keybase
winget install --no-upgrade --id Microsoft.VisualStudioCode
winget install --no-upgrade --id QMK.QMKToolbox
winget install --no-upgrade --id VideoLAN.VLC
winget install --no-upgrade --id Rustlang.Rustup
winget install --no-upgrade --id flux.flux

choco install -y starship fd lf ripgrep

# choco install -y alacritty --pre
# choco install -y neovim --pre
#
# choco install -y 7Zip.install
# choco install -y autohotkey
# choco install -y brave
# choco install -y dashlane
# choco install -y discord
# choco install -y docker
# choco install -y everything
# choco install -y f.lux
# choco install -y firefox
# choco install -y keybase
# choco install -y rufus
# choco install -y spotify
# choco install -y steam
# choco install -y teracopy
# choco install -y vscode
# # choco install -y visualstudio2019community
# choco install -y windirstat
#
# choco install -y cmake
# choco install -y fd
# choco install -y fzf
# choco install -y git
# choco install -y git-lfs
# choco install -y lf
# choco install -y ripgrep
# choco install -y yarn
#
# # Programming lang
# choco install -y rust-analyzer
# choco install -y rustup.install
# choco install -y golang
#
# # Digital Audio Workstation
# choco install -y audacity
# # choco install -y reaper
#
# # Image processing
# choco install -y gimp
# # choco install -y krita
# # choco install -y inkscape
#
# # Maybe???
# # choco install -y vcxsrv
# # choco install -y treesizefree
