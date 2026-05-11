#!/usr/bin/env bash
# Bootstrap this Neovim config on Ubuntu, Debian, Fedora, Arch, openSUSE.
# Installs system dependencies, ensures Neovim >= 0.12, optionally installs the
# config into ~/.config/nvim, and runs the headless plugin/build bootstrap.

set -euo pipefail

#---------------------------------------- args / globals
FORCE=0
NO_BOOTSTRAP=0
USE_APPIMAGE=0
NO_APPIMAGE=0
ASSUME_YES=0
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_MIN_MAJOR=0
NVIM_MIN_MINOR=12

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --force          Overwrite ~/.config/nvim if it exists (a backup is made first)
  --no-bootstrap   Install system packages only; skip plugin/LSP/treesitter bootstrap
  --appimage       Install Neovim via the official AppImage instead of distro packages
                   (default on Ubuntu/Debian, since their packaged Neovim is usually too old)
  --no-appimage    Force use of the distro's Neovim package, even on Ubuntu/Debian
  --yes            Don't prompt; assume yes to interactive questions
  -h, --help       Show this help

Supported distros: Ubuntu, Debian, Fedora, Arch (incl. Manjaro), openSUSE.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force)        FORCE=1 ;;
        --no-bootstrap) NO_BOOTSTRAP=1 ;;
        --appimage)     USE_APPIMAGE=1 ;;
        --no-appimage)  NO_APPIMAGE=1 ;;
        --yes|-y)       ASSUME_YES=1 ;;
        -h|--help)      usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
    esac
    shift
done

#---------------------------------------- logging
c_blue='\033[1;34m'; c_green='\033[1;32m'; c_yellow='\033[1;33m'; c_red='\033[1;31m'; c_reset='\033[0m'
info()  { printf "${c_blue}[*]${c_reset} %s\n" "$*"; }
ok()    { printf "${c_green}[+]${c_reset} %s\n" "$*"; }
warn()  { printf "${c_yellow}[!]${c_reset} %s\n" "$*" >&2; }
fail()  { printf "${c_red}[x]${c_reset} %s\n" "$*" >&2; exit 1; }

confirm() {
    [[ $ASSUME_YES -eq 1 ]] && return 0
    local prompt="${1:-Continue?} [y/N] "
    read -r -p "$prompt" reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

#---------------------------------------- distro detection
detect_distro() {
    [[ -r /etc/os-release ]] || fail "/etc/os-release missing — cannot detect distro."
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO_ID="${ID:-}"
    DISTRO_LIKE="${ID_LIKE:-}"

    case " $DISTRO_ID $DISTRO_LIKE " in
        *" ubuntu "*|*" debian "*) PKG=apt ;;
        *" fedora "*|*" rhel "*|*" centos "*) PKG=dnf ;;
        *" arch "*|*" manjaro "*) PKG=pacman ;;
        *" opensuse "*|*" suse "*|*" opensuse-tumbleweed "*|*" opensuse-leap "*) PKG=zypper ;;
        *)
            case "$DISTRO_ID" in
                ubuntu|debian) PKG=apt ;;
                fedora) PKG=dnf ;;
                arch|manjaro|endeavouros) PKG=pacman ;;
                opensuse*|sles) PKG=zypper ;;
                *) fail "Unsupported distro: ID=$DISTRO_ID ID_LIKE=$DISTRO_LIKE" ;;
            esac
            ;;
    esac
    ok "Detected distro: $DISTRO_ID (using $PKG)"
}

SUDO=""
need_sudo() {
    if [[ $EUID -ne 0 ]]; then
        command -v sudo >/dev/null 2>&1 || fail "sudo not found; run this script as root."
        SUDO="sudo"
    fi
}

#---------------------------------------- package installers
install_apt() {
    need_sudo
    $SUDO apt-get update -y
    # NOTE: Neovim is intentionally omitted here — Ubuntu/Debian packages lag
    # behind the 0.12+ this config needs. ensure_neovim() installs the AppImage.
    $SUDO apt-get install -y \
        git curl unzip tar fuse libfuse2 \
        build-essential pkg-config \
        ripgrep fd-find \
        xclip wl-clipboard \
        nodejs npm \
        python3 python3-pip python3-venv \
        default-jre-headless || warn "default-jre-headless not available; jdtls may fail."

    # Rust toolchain (Debian/Ubuntu names it rustc + cargo)
    $SUDO apt-get install -y rustc cargo || warn "Rust toolchain install failed; blink.cmp will fall back to Lua matcher."

    # fd-find ships the binary as 'fdfind' on Debian/Ubuntu — symlink to 'fd'.
    if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        ok "Linked fdfind -> ~/.local/bin/fd"
    fi
}

install_dnf() {
    need_sudo
    $SUDO dnf install -y \
        neovim git curl unzip tar \
        @development-tools \
        ripgrep fd-find \
        xclip wl-clipboard \
        nodejs npm \
        python3 python3-pip \
        rust cargo \
        java-latest-openjdk-headless || true
}

install_pacman() {
    need_sudo
    $SUDO pacman -Sy --needed --noconfirm \
        neovim git curl unzip tar \
        base-devel \
        ripgrep fd \
        xclip wl-clipboard \
        nodejs npm \
        python python-pip \
        rust \
        jre-openjdk-headless || true
}

install_zypper() {
    need_sudo
    $SUDO zypper --non-interactive refresh
    $SUDO zypper --non-interactive install \
        neovim git curl unzip tar \
        patterns-devel-base-devel_basis gcc gcc-c++ make pkg-config \
        ripgrep fd \
        xclip wl-clipboard \
        nodejs npm \
        python3 python3-pip \
        rust cargo \
        java-21-openjdk-headless || \
    $SUDO zypper --non-interactive install java-17-openjdk-headless || true
}

install_packages() {
    case "$PKG" in
        apt)    install_apt ;;
        dnf)    install_dnf ;;
        pacman) install_pacman ;;
        zypper) install_zypper ;;
        *) fail "Unknown package manager: $PKG" ;;
    esac
    ok "System packages installed."
}

#---------------------------------------- neovim version handling
nvim_version_ok() {
    command -v nvim >/dev/null 2>&1 || return 1
    local ver
    ver="$(nvim --version | head -1 | awk '{print $2}' | sed 's/^v//')"
    local major minor
    major="$(echo "$ver" | awk -F. '{print $1}')"
    minor="$(echo "$ver" | awk -F. '{print $2}')"
    [[ -z "$major" || -z "$minor" ]] && return 1
    if (( major > NVIM_MIN_MAJOR )); then return 0; fi
    if (( major == NVIM_MIN_MAJOR && minor >= NVIM_MIN_MINOR )); then return 0; fi
    return 1
}

install_appimage() {
    info "Installing Neovim AppImage to ~/.local/bin/nvim"
    mkdir -p "$HOME/.local/bin"
    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
    local tmp
    tmp="$(mktemp)"
    curl -fsSL "$url" -o "$tmp" || fail "Failed to download Neovim AppImage."
    chmod +x "$tmp"
    mv "$tmp" "$HOME/.local/bin/nvim"
    if ! [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
        warn "~/.local/bin is not in your PATH. Add it to your shell rc (export PATH=\"\$HOME/.local/bin:\$PATH\")."
    fi
    ok "Neovim AppImage installed."
}

ensure_neovim() {
    # On Debian/Ubuntu, default to AppImage unless the user explicitly opted out.
    if [[ $PKG == "apt" && $NO_APPIMAGE -ne 1 ]]; then
        USE_APPIMAGE=1
    fi

    if [[ $USE_APPIMAGE -eq 1 ]]; then
        install_appimage
    elif nvim_version_ok; then
        ok "Neovim $(nvim --version | head -1 | awk '{print $2}') satisfies >= 0.12."
    else
        warn "Neovim is missing or older than 0.12."
        if [[ $ASSUME_YES -eq 1 ]] || confirm "Download the official AppImage to ~/.local/bin/nvim?"; then
            install_appimage
        else
            fail "Need Neovim >= 0.12. Re-run with --appimage or install a newer build manually."
        fi
    fi
    nvim_version_ok || fail "Neovim still < 0.12 after install."
}

#---------------------------------------- config link
link_config() {
    if [[ "$REPO_DIR" == "$NVIM_CONFIG_DIR" ]]; then
        ok "Running from $NVIM_CONFIG_DIR — no copy needed."
        return
    fi

    if [[ -e "$NVIM_CONFIG_DIR" || -L "$NVIM_CONFIG_DIR" ]]; then
        if [[ $FORCE -ne 1 ]]; then
            fail "$NVIM_CONFIG_DIR already exists. Re-run with --force to back it up and replace."
        fi
        local backup="${NVIM_CONFIG_DIR}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$NVIM_CONFIG_DIR" "$backup"
        ok "Backed up existing config to $backup"
    fi

    mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
    ln -s "$REPO_DIR" "$NVIM_CONFIG_DIR"
    ok "Linked $REPO_DIR -> $NVIM_CONFIG_DIR"
}

#---------------------------------------- bootstrap
bootstrap_nvim() {
    info "Bootstrapping plugins, LSPs, treesitter parsers (this may take a few minutes)..."
    # vim.pack runs as part of init; we just need to start headlessly so it fires.
    # Two passes: first install plugins, second TSUpdate after parsers are reachable.
    nvim --headless +"qall!" || warn "First headless start exited non-zero (often benign on first plugin install)."
    nvim --headless +"TSUpdate" +"qall!" || warn "TSUpdate reported issues — re-run :TSUpdate inside nvim if parsers are missing."

    # markdown-preview npm bootstrap
    local mp_dir="$HOME/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app"
    if [[ -d "$mp_dir" ]] && command -v npm >/dev/null 2>&1; then
        info "Installing markdown-preview node modules..."
        ( cd "$mp_dir" && npm install --silent ) || warn "markdown-preview npm install failed; markdown preview may not work."
    fi
    ok "Bootstrap complete."
}

#---------------------------------------- main
main() {
    detect_distro
    install_packages
    ensure_neovim
    link_config
    if [[ $NO_BOOTSTRAP -eq 1 ]]; then
        ok "Skipping plugin bootstrap (--no-bootstrap)."
    else
        bootstrap_nvim
    fi
    ok "Done. Launch with: nvim"
    info "Tip: open nvim and run :checkhealth to verify LSP, treesitter, mason, and blink."
}

main "$@"
