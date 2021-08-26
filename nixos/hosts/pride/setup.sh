#!/bin/sh

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -4GiB
parted /dev/sda -- mkpart primary linux-swap -4GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkfs.fat -F 32 -n boot /dev/sda3
mkswap -L swap /dev/sda2
swapon /dev/sda2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

