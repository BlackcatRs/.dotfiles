#!/usr/local/env bash

readonly SCRIPT_DIR=$(dirname -- "$(readlink -f -- \
"${BASH_SOURCE[0]}")")

SCRIPT_DST="/usr/local/bin"
SYSTEMD_DST="/etc/systemd/system"

SCRIPTS=(
    "vts-syncthing-init"
    "vts-syncthing-perm"    
)

F_UNITS=(
    "vts-syncthing-init.service"
    "vts-syncthing-perm.service"
)


for script in "${SCRIPTS[@]}"; do
    [[ ! -f "${script}" ]] && exit 1
    
    cp "${SCRIPT_DIR}/${script}" "${SCRIPT_DST}/"
    chown root:root "${SCRIPT_DST}/${script}"
    chmod 700 "${SCRIPT_DST}/${script}"
done


for unit in "${F_UNITS[@]}"; do
    [[ ! -f "${unit}" ]] && exit 2
    
    cp "${SCRIPT_DIR}/${unit}" "${SYSTEMD_DST}/"
    chown root:root "${SYSTEMD_DST}/${unit}"
    chmod 600 "${SYSTEMD_DST}/${unit}"
done

systemctl daemon-reload


for unit in "${F_UNITS[@]}"; do
    systemctl enable --now "${unit}"
done
