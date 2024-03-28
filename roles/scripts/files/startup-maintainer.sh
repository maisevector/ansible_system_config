#!/bin/bash

list_packages() {
    # Get distro type
    DISTRO=$(cat /etc/os-release | grep -o "^ID=.*" | sed 's/ID=//g')
    explicit_orphan_file=${maintenance_dir}/explicit_orphans.txt
    explicitly_instaled_packages_file=${maintenance_dir}/explicitly_installed_packages.txt
    if [[ "${DISTRO}" = "arch" ]]; then
        pacman -Qqe > $explicitly_instaled_packages_file
        pacman -Qtdq > $explicit_orphan_file
        # Remvoe using $ pacman -Qtdq | sudo pacman -Rns -
        # Notification for desktop
        notify-send "$(borg list /run/media/maise/263af216-9e6b-4a90-b958-ed2da017c8b6/arch_backup/ | tail -n 1 | awk '{print $1}')"
    elif [[ "${DISTRO}" = "fedora" ]]; then
        dnf history userinstalled > $explicitly_instaled_packages_file
        dnf repoquery --extras > $explicit_orphan_file
        dnf repoquery --unneeded >> $explicit_orphan_file
        # Remove using $ dnf autoremove
    elif [[ "${DISTRO}" = "debian" ]]; then
        apt-mark showmanual > $explicitly_instaled_packages_file
        deborphan --guess-all > $explicit_orphan_file
        # Remove using $ apt-get autoremove
    fi
}

find_large_files() {
    large_files_file=${maintenance_dir}/large_files.txt
    find $HOME -size +1G > ${large_files_file}
}

list_flatpaks() {
    flatpak_file=${maintenance_dir}/flatpaks.txt
    flatpak --columns=app list > ${flatpak_file}
}

dump_dconf() {
    dconf dump / > ${maintenance_dir}/dconf_dump.txt
}

main() {
    maintenance_dir="$HOME/.maintenance"
    mkdir -p ${maintenance_dir}
    list_packages
    find_large_files
}

main

### rmlint look for duplicates ###
# Not sure if I currently want to do this every time?
# find $HOME -not \( -type d \( -path $HOME/.thunderbird -o -path $HOME/.cache -o -path $HOME/.mozilla \) -prune \) -print0 | rmlint -o json:$HOME/.maintenance/rmlint_maintenance.json -o sh:$HOME/.maintenance/rmlint_maintenance.sh -o summary:stdout - > $HOME/.maintenance/rmlint_maintenance.txt
