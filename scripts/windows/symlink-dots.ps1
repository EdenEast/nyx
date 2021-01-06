<#
.DESCRIPTION
    Symlink configuration files and folder to work with windows application and setup.
#>
param (
    [Parameter(Mandatory = $false)][switch]$Force,
    [Parameter(Mandatory = $false)][string]$Backup = ".bak"
)

function HandleSymlink([string]$path, [string]$target) {
    if (Test-Path $path) {
        $file = Get-Item -LiteralPath $path
        $is_symlink = $file.LinkType -eq "HardLink" -or $file.LinkType -eq "SymbolicLink"
        if ($is_symlink) {
            $current_target = $file | Select-Object -ExpandProperty Target
            if ($current_target -ne $target) {
                New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                if ($?) { Write-Host "Writing link: $path from $current_target -> $target" }
            }
        } else {
            if ($Force) {
                $backup_path = "$path$Backup"
                Move-Item -Path $path -Destination $backup_path -Force
                if ($?) { Write-Host "Backup: $path -> $backup_path" } else{ continue }

                New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                if ($?) { Write-Host "Writing link: $path $target" }
            } else {
                Write-Error "Path: $path already exists";
            }
        }
    } else {
        # Get parent directory and create it if it does not exist
        $parent = [System.Io.Path]::GetDirectoryName($path)
        [System.Io.Directory]::CreateDirectory($parent) | Out-Null

        New-Item -ItemType SymbolicLink -Path $path -Target $target | Out-Null
        if ($?) { Write-Host "Symlink $path -> $target" }
    }
}

# Get the root directory of nyx
$NyxRootDir = (get-item $PSScriptRoot).parent.parent.FullName

$ConfigHome = Join-Path -Path $HOME -ChildPath .config
$LocalHome = Join-Path -Path $HOME -ChildPath .local
$AppRoaming = $env:APPDATA;
$AppLocal = $env:LOCALAPPDATA;

$NyxDotHome = [IO.Path]::Combine($NyxRootDir, 'home', 'files')
foreach ($child in Get-ChildItem -Path $NyxDotHome -Force) {
    $path = Join-Path -Path $HOME -ChildPath $child
    HandleSymlink $path $child.FullName
}

# Alacritty
$AlacrittySource = [IO.Path]::Combine($AppRoaming, 'alacritty', 'alacritty.yml')
$AlacrittyTarget = [IO.Path]::Combine($ConfigHome, 'alacritty', 'alacritty.yml')
HandleSymlink $AlacrittySource $AlacrittyTarget

# Neovim
$NvimSource = [IO.Path]::Combine($AppLocal, 'nvim')
$NvimTarget = [IO.Path]::Combine($ConfigHome, 'nvim')
HandleSymlink $NvimSource $NvimTarget

