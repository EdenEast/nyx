<#
.DESCRIPTION
    Symlink configuration files and folder to work with windows application and setup.
#>
param (
    [Parameter(Mandatory = $false)][switch]$Dryrun,
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
                if ($Dryrun) {
                    Write-Host "Would link: $path from $current_target -> $target"
                } else {
                    New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                    if ($?) { Write-Host "Writing link: $path from $current_target -> $target" }
                }
            }
        } else {
            if ($Force) {
                $backup_path = "$path$Backup"
                Move-Item -Path $path -Destination $backup_path -Force
                if ($?) { Write-Host "Backup: $path -> $backup_path" } else{ continue }

                New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                if ($?) { Write-Host "Writing link: $path $target" }
            } else {
                Write-Host "Skipping as path exists and is not a synlink: $path"
            }
        }
    } else {
        if ($Dryrun) {
            Write-Host "Would create Directory: $parent"
            Write-Host "Would link: $path -> $target"
        } else {
            # Get parent directory and create it if it does not exist
            $parent = [System.Io.Path]::GetDirectoryName($path)
            [System.Io.Directory]::CreateDirectory($parent) | Out-Null

            New-Item -ItemType SymbolicLink -Path "$path" -Target "$target" | Out-Null
            if ($?) { Write-Host "Symlink $path -> $target" }
        }
    }
}

function Write-Ok([string] $message) {
    Write-Host "[ Ok ]: " -ForegroundColor green -NoNewline
    Write-Host $message
}

function Write-Skip([string] $message) {
    Write-Host "[Skip]: " -ForegroundColor magenta -NoNewline
    Write-Host $message
}

function Write-Warn([string] $message) {
    Write-Host "[Warn]: " -ForegroundColor yellow -NoNewline
    Write-Host $message
}

function Write-Fail([string] $message) {
    Write-Host "[Fail]: " -ForegroundColor red -NoNewline
    Write-Host $message
    Write-Error "Failed with message: $message"
}

# function Symlink([string]$source, [string]$target) {
#     if (Test-Path $source) {
#         if (Test-Path $target) {
#             $target_item = Get-Item -LiteralPath $target
#             $is_symlink = $target_item.LinkType -eq "HardLink" -or $target_item.LinkType -eq "SymbolicLink"
#             if ($is_symlink) {
#                 $current_target = $target_item | Select-Object -ExpandProperty Target
#                 if ($current_target -ne $target ) {
#                     if (!$Dryrun) {
#                     }
#                     Write-Ok ""
#                 } else {
#                     Write-Skip "target $target is already linked to $source"
#                 }
#             } else {
#             }
#         } else {
#             Write-Ok "create link $target pointing to $source"
#             if (!$Dryrun) {
#                 New-Item -ItemType SymbolicLink -Path $target -Value $source
#             }
#         }
#         # $is_symlink = $file.LinkType -eq "HardLink" -or $file.LinkType -eq "SymbolicLink"
#         # if ($is_symlink) {
#         #     $current_target = $file | Select-Object -ExpandProperty Target
#         #     if ($current_target -ne $target) {
#         #         Write-Ok "target link location: $target "
#         #     }
#         # }
#     } else {
#         Write-Fail "Path $source is unknown"
#     }
# }

function Symlink([string]$link, [string]$target) {
    if (Test-Path $link) {
        if (Test-Path $target) {
            $file = Get-Item -LiteralPath $target
            $is_symlink = $file.LinkType -eq "HardLink" -or $file.LinkType -eq "SymbolicLink"
            if ($is_symlink) {
                $current = $file | Select-Object -ExpandProperty Target
                if ($current -ne $target) {
                    if (!$Dryrun) {
                        New-Item -ItemType SymbolicLink -Path $link -Target $target -Force | Out-Null
                    }
                    if ($? -or $Dryrun) {
                        Write-Ok "redirecting link $target from $current to $link"
                    }
                } else {
                    Write-Skip "link $target already linked to $link"
                }
            } else {
                if ($Force) {
                    $backup_path = "$path$Backup"
                    Move-Item -Path $path -Destination $backup_path -Force
                    if ($? -or $Dryrun) {
                        Write-Ok "Backing up: $link to $backup_path"
                    } else {
                        continue
                    }

                    New-Item -ItemType SymbolicLink -Path $link -Target $target -Force | Out-Null
                    Write-Ok "link $target to $link"
                } else {
                    Write-Warn "target $target already exists and is not a symlink"
                }
            }
        } else {
            # Get parent directory and create it if it does not exist
            $parent = [System.Io.Path]::GetDirectoryName($link)
            [System.Io.Directory]::CreateDirectory($parent) | Out-Null

            if (!$Dryrun) {
                New-Item -ItemType SymbolicLink -Path $link -Target $target | Out-Null
            }
            if ($? -or $Dryrun) {
                Write-Ok "link $target to $link"
            }
        }
    } else {
        Write-Fail "Path $link is unknown"
    }
}

# Get the root directory of nyx
$NyxRootDir = (get-item $PSScriptRoot).parent.parent.FullName
$WinDir = [IO.Path]::Combine($NyxRootDir, "windows", "bin")


$ConfigHome = Join-Path -Path $HOME -ChildPath .config
$LocalHome = Join-Path -Path $HOME -ChildPath .local
$AppRoaming = $env:APPDATA;
$AppLocal = $env:LOCALAPPDATA;
$StartupDir = [IO.Path]::Combine($AppRoaming, "Microsoft", "Windows", "Start Menu", "Programs", "Startup")
$NyxConfigHome = [IO.Path]::Combine($NyxRootDir, "config", ".config")

$NvimSource = [IO.Path]::Combine($NyxConfigHome, "nvim")
$NvimTarget = [IO.Path]::Combine($AppRoaming, "nvim")

# $Dryrun = $true
Symlink $NvimSource $NvimTarget

# $NyxDotHome = [IO.Path]::Combine($NyxRootDir, 'config')
# foreach ($child in Get-ChildItem -Path $NyxDotHome -Force) {
#     $path = Join-Path -Path $HOME -ChildPath $child
#     Symlink $path $child.FullName
# }
#
# # Alacritty
# $AlacrittySource = [IO.Path]::Combine($AppRoaming, 'alacritty', 'alacritty.yml')
# $AlacrittyTarget = [IO.Path]::Combine($ConfigHome, 'alacritty', 'alacritty.yml')
# Symlink $AlacrittySource $AlacrittyTarget
#
# # Neovim
# $NvimSource = [IO.Path]::Combine($AppLocal, 'nvim')
# $NvimTarget = [IO.Path]::Combine($ConfigHome, 'nvim')
# Symlink $NvimSource $NvimTarget
#
# # Nushell
# $NushellSource = [IO.Path]::Combine($AppRoaming, 'nushell')
# $NushellTarget = [IO.Path]::Combine($ConfigHome, 'nvim')
# Symlink $NushellSource $NushellTarget
#
# # # Autohotkey caps remap to ctrl/escape
# # $AutohotkeySource = [IO.Path]::Combine($StartupDir, "caps-to-ctrl+esc.ahk")
# # $AutohotkeyTarget = [IO.Path]::Combine($WinDir, "caps-to-ctrl+esc.ahk")
# # Symlink $AutohotkeySource $AutohotkeyTarget
#
# # KMonad settings on startup
# # $KMonadSource = [IO.Path]::Combine($StartupDir, "kmonad-startup.ps1")
# # $KMonadTarget = [IO.Path]::Combine($WinDir, "kmonad-startup.ps1")
# # Symlink $KMonadSource $KMonadTarget
#
