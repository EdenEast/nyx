<#
.DESCRIPTION
    Install chocolatey if exists
#>

# Check if 'choco' is installed
if ((Get-Command "choco.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco install -y alacritty --pre
choco install -y neovim --pre

choco install -y 7Zip.install
choco install -y autohotkey
choco install -y brave
choco install -y dashlane
choco install -y discord
choco install -y docker
choco install -y everything
choco install -y f.lux
choco install -y firefox
choco install -y keybase
choco install -y rufus
choco install -y spotify
choco install -y steam
choco install -y teracopy
choco install -y vscode
# choco install -y visualstudio2019community
choco install -y windirstat

choco install -y cmake
choco install -y fd
choco install -y fzf
choco install -y git
choco install -y git-lfs
choco install -y lf
choco install -y ripgrep
choco install -y yarn

# Programming lang
choco install -y rust-analyzer
choco install -y rustup.install
choco install -y golang

# Digital Audio Workstation
choco install -y audacity
# choco install -y reaper

# Image processing
choco install -y gimp
# choco install -y krita
# choco install -y inkscape

# Maybe???
# choco install -y vcxsrv
# choco install -y treesizefree
