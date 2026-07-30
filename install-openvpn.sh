#!/usr/bin/env bash

set -Eeuo pipefail

readonly INSTALL_DIR="/opt/openvpn/openvpn-install"
readonly REPOSITORY_URL="https://github.com/Nyr/openvpn-install.git"

if [[ "${EUID}" -ne 0 ]]; then
    echo "Error: ejecuta este script como root:"
    echo "sudo bash $0"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "Actualizando la lista de paquetes..."
apt-get update

echo "Actualizando los paquetes del servidor..."
apt-get upgrade -y

echo "Instalando dependencias..."
apt-get install -y \
    tor \
    git \
    autoconf \
    automake \
    make \
    libtool \
    gcc \
    ca-certificates

mkdir -p "$(dirname "${INSTALL_DIR}")"

if [[ -d "${INSTALL_DIR}/.git" ]]; then
    echo "Actualizando el repositorio existente..."
    git -C "${INSTALL_DIR}" pull --ff-only
else
    echo "Descargando OpenVPN Installer..."
    git clone --depth 1 "${REPOSITORY_URL}" "${INSTALL_DIR}"
fi

chmod 750 "${INSTALL_DIR}/openvpn-install.sh"

echo "Iniciando la instalación de OpenVPN..."
exec "${INSTALL_DIR}/openvpn-install.sh"