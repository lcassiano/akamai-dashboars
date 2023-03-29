#!/bin/sh
set -e
set -o noglob

# --- helper functions for logs ---
info() {
    echo '[INFO] ' "$@"
}
warn() {
    echo '[WARN] ' "$@" >&2
}
fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# --- setup dependencies for Akamai SIEM ---
setup_env() {
    info $AKAMAIHOST
}

# --- setup dependencies for Akamai SIEM ---
setup_dependencies() {
    if [[ -f /etc/apt/sources.list ]]; then
        package_installer=apt
    elif [[ -f /etc/yum.conf ]]; then
        package_installer=yum
    else
        fatal 'No change detected so skipping service start'
        return
    fi

    info 'Update packages'
    ${package_installer} -y update
    info 'Installing dependencies'
    ${package_installer} install -y git curl

}

# --- setup K3S to use kubernets ---
setup_k3s() {
    info "Install k3s from https://get.k3s.io"
    curl -sfL https://get.k3s.io | sh -
    ln -s /etc/rancher/k3s/k3s.yaml kubeconfig
}

# --- run the install process --
{
    setup_dependencies
    setup_env
    setup_k3s
}