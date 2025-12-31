<#
.DESCRIPTION
    Symlink configuration files and folder to work with windows application and setup.
#>

$yubikeyName = Get-PnpDevice -Class SoftwareDevice | Where-Object {$_.FriendlyName -like "*YubiKey*"} | Select-Object -ExpandProperty FriendlyName
$gpgFolder = [IO.Path]::Combine($Env:APPDATA, 'gnupg')

$Env.APPDATA
$gpgFolder


New-Item -Path $gpgFolder -ItemType "directory" -Force

$gpgContent = @"
enable-ssh-support
enable-putty-support
"@

$gpgAgentFile = [IO.Path]::Combine($gpgFolder, "gpg-agent.conf")
Out-File -FilePath $gpgAgentFile -InputObject $gpgContent -Force

$scdaemonContent = "reader-port {0}" -f $yubikeyName
$gpgScdaemonFile = [IO.Path]::Combine($gpgFolder, "scdaemon.conf")
Out-File -FilePath $gpgScdaemonFile -InputObject $scdaemonContent -Force
