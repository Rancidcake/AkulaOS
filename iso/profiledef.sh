#!/usr/bin/env bash
# AkulaOS archiso profile definition.
# Build with: sudo bash iso/build.sh

iso_name="akula-os"
iso_label="AKULA_OS"
iso_publisher="AkulaOS <https://github.com/Rancidcake/AkulaOS>"
iso_application="AkulaOS Installer"
iso_version="0.1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=(
    'bios.syslinux'
    'uefi.grub'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15')
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/root/customize_airootfs.sh"]="0:0:755"
)
