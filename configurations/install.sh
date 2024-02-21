#! /usr/bin/env bash

# exit when any command fails
set -e

root_label="root"
boot_label="boot"
nix_label="nix"
persist_label="persist"
swap_label="swap"
boot_device="/dev/disk/by-partlabel/$boot_label"
root_device="/dev/disk/by-partlabel/$root_label"
boot_part_num=1
root_part_num=2
tmp_mount_point="/mnt"
boot_mount_point="${tmp_mount_point}/${boot_label}"
nix_mount_point="${tmp_mount_point}/${nix_label}"
persist_mount_point="${tmp_mount_point}/${persist_label}"
swap_mount_point="${tmp_mount_point}/${swap_label}"
luks_name="luksroot"
luks_device="/dev/mapper/$luks_name"
btrfs_top_level="/tmp/$root_label"

# connect to the wifi network
wifi_connect() {
  printf "\n\nConnecting to '3C9C 5Ghz' wifi\n"
  until nmcli --ask device wifi connect '3C9C 5Ghz'
  do printf "\n\nIncorrect password. try again.\n"; done
}

# delete the partition table of a disk
wipe_disk() {
  local device="$1"
  printf "\n\nWiping %s disk\n" "$device"
  wipefs --all --force "$device"
}

# create boot and root partitions and add correct types and partlabels
partition_disk() {
  local device="$1"
  printf "\n\nCreating boot and root partitions in %s\n" "$device"
  sgdisk \
    -n "$boot_part_num"::+500m \
    -t "$boot_part_num":ef00   \
    -c "$boot_part_num":"$boot_label" \
    -n "$root_part_num"::0     \
    -t "$root_part_num":8304   \
    -c "$root_part_num":"$root_label" \
    -p "$device"
  }

format_luks() {
  printf "\n\nEncrypting root partition with luks\n"
  until cryptsetup -v luksFormat "$root_device"
  do printf "\n\nIncorrect password. try again.\n"; done
}

open_luks() {
  printf "\n\nOpening encrypted partition and mapping it to \"%s\"\n" "$luks_name"
  until cryptsetup -v open "$root_device" "$luks_name"
  do printf "\n\nIncorrect password. try again.\n"; done
}

format_partitions() {
  printf "\n\nCreating FAT32 (boot) and BTRFS (root) filesystems\n"
  mkfs.vfat "$boot_device"
  mkfs.btrfs "$luks_device"
}

create_subvolumes() {
  printf "\n\nMounting top-level btrfs sub-volume to %s\n" "$btrfs_top_level"
  mkdir -pv "$btrfs_top_level"
  mount "$luks_device" "$btrfs_top_level"
  printf "\n\nCreating btrfs subvolumes\n"
  btrfs subvolume create "${btrfs_top_level}/${nix_label}"
  btrfs subvolume create "${btrfs_top_level}/${persist_label}"
  btrfs subvolume create "${btrfs_top_level}/${swap_label}"
  printf "\n\nUnmounting top-level btrfs sub-volume\n"
  umount -v "$btrfs_top_level"
}

mount_partitions() {
  printf "\n\nMounting root tmpfs to /mnt\n"
  mount -t tmpfs none "$tmp_mount_point"
  printf "\n\nMounting top-level btrfs sub-volume to %s\n" "$btrfs_top_level"
  mkdir -pv "$btrfs_top_level"
  mount "$luks_device" "$btrfs_top_level"
  printf "\n\nMounting boot partition\n"
  mkdir -vp "$boot_mount_point"
  mount -v "$boot_device" "$boot_mount_point"
  printf "\n\nMounting BTRFS subvolumes\n"
  mkdir -vp "${tmp_mount_point}"/{"${nix_label}","${persist_label}","${swap_label}"}
  mount -vo "subvol=${nix_label},compress=zstd,noatime" "$luks_device" "$nix_mount_point"
  mount -vo "subvol=${persist_label},compress=zstd,noatime" "$luks_device" "$persist_mount_point"
  mount -vo "subvol=${swap_label},compress=zstd,noatime" "$luks_device" "$swap_mount_point"
  printf "\n\nCreating persist dirs\n"
  mkdir -vp "${persist_mount_point}"/{system,home}
}

create_passwords() {
  printf "\n\nSet \"carles\" user password\n"
  mkdir -vp /mnt/persist/system/passwords
  mkpasswd --method=yescrypt --rounds=11 > /mnt/persist/system/passwords/carles
}

clone_repos() {
  local dotfiles_path='/mnt/persist/home/carles/.config/dotfiles'
  local dotfiles_https_repo='https://github.com/karb94/dotfiles.git' 
  local dotfiles_ssh_repo='git@github.com:karb94/nixos-config.git'
  mkdir -vp "$dotfiles_path"
  git clone -b nixos --single-branch "$dotfiles_https_repo" "$dotfiles_path"
  git -C "$dotfiles_path" remote set-url origin "$dotfiles_ssh_repo"

  local nixos_config_path='/mnt/persist/system/etc/nixos'
  local nixos_config_https_repo='https://github.com/karb94/nixos-config.git' 
  local nixos_config_ssh_repo='git@github.com:karb94/nixos-config.git'
  mkdir -vp "$nixos_config_path"
  git clone -b master --single-branch "$nixos_config_https_repo" "$nixos_config_path"
  git -C "$nixos_config_path" remote set-url origin "$nixos_config_ssh_repo"
  chown -R 1000:100 "$nixos_config_path"
}

get_ssh_key() {
  local id_ed25519_pub="/mnt/persist/home/carles/.ssh/id_ed25519.pub"
  local id_ed25519="/mnt/persist/home/carles/.ssh/id_ed25519"
  mkdir -vp "/mnt/persist/home/carles/.ssh"
  local bw_session=$(bw login --raw)
  bw get notes "London desktop ssh public key" --session "$bw_session" > "$id_ed25519_pub"
  bw get notes "London desktop ssh private key" --session "$bw_session" > "$id_ed25519"
  bw lock
  chown 1000:100 "$id_ed25519_pub"
  chown 1000:100 "$id_ed25519"
  chmod 644 "$id_ed25519_pub"
  chmod 600 "$id_ed25519"
}

install_nixos() {
  printf "\n\nInstalling nixos\n"
  nixos-install --no-root-passwd --flake 'github:karb94/nixos-config#brutus'
}

format_disk() {
  local device=$1
  wipe_disk "$device"
  partition_disk "$device"
  format_luks
  open_luks
  format_partitions
  create_subvolumes
  mount_partitions
  create_passwords
  wifi_connect
  clone_repos
  get_ssh_key
  chown 1000:100 "/mnt/persist/home"
  chown -R 1000:100 "/mnt/persist/home/carles"
  chmod 644 "$id_ed25519_pub"
  install_nixos
}
