#!/usr/bin/bash

# Configure mirrorlist
tee /etc/pacman.d/mirrorlist << 'EOF'
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
EOF

# Init and populate keyring
pacman-key --init
pacman-key --populate

# Configure Pacman
sed -i "s|^#Color|Color|g" /etc/pacman.conf
sed -i "s|^#VerbosePkgLists|VerbosePkgLists|g" /etc/pacman.conf
sed -i "s|^#ParallelDownloads.*|ParallelDownloads = 5|g" /etc/pacman.conf
sed -i "/ParallelDownloads = 5/a ILoveCandy" /etc/pacman.conf

# Update packages
pacman -Syu --noconfirm

# Install base packages
pacman -S --noconfirm base base-devel

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf
locale-gen

# Set keymap
echo "KEYMAP=us" > /etc/vconsole.conf

# Set hostname
echo archlinux > /etc/hostname

# Set /etc/hosts
tee /etc/hosts << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 archlinux.localdomain archlinux
EOF

# Install common applications
pacman -S --noconfirm \
    coreutils \
    htop \
    git \
    p7zip \
    unzip \
    unrar \
    lm_sensors \
    upower \
    nano \
    wget \
    openssh \
    fwupd \
    zstd \
    lzop \
    man-db \
    man-pages \
    e2fsprogs \
    util-linux \
    rsync \
    jq \
    yq \
    lazygit \
    ripgrep \
    fd \
    gptfdisk \
    bc \
    cpupower \
    procps-ng \
    gawk \
    fzf \
    findutils \
    net-tools \
    bind

# Create local bin directory
mkdir -p /home/wsl/.local/bin

# Install bash
pacman -S --noconfirm bash

# Create bash configs directory
mkdir -p /home/wsl/.bashrc.d

# Configure bash
tee -a /home/wsl/.bashrc << 'EOF'

# Add .local.bin to path
PATH=$PATH:/home/wsl/.local/bin

# Source .bashrc.d files
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi
EOF

# Change root password
passwd

# Setup user
useradd -m -G wheel -s /usr/bin/bash wsl
passwd wsl
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Configure WSL
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#change-the-default-user-for-a-distribution
tee /etc/wsl.conf << 'EOF'
[boot]
systemd=true

[user]
default=wsl

# [automount]
# enabled=false
EOF

# Create SSH directory and config file
mkdir -p /home/wsl/.ssh
chown 700 /home/wsl/.ssh
tee /home/wsl/.ssh/config << EOF
Host *
    ServerAliveInterval 60
EOF

# Install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /home/wsl/.local/bin
mkdir -p /etc/oh-my-posh/themes
curl https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/powerlevel10k_lean.omp.json -o /etc/oh-my-posh/themes/powerlevel10k_lean.omp.json
tee /home/wsl/.bashrc.d/oh-my-posh << 'EOF'
eval "$(oh-my-posh init bash --config /etc/oh-my-posh/themes/powerlevel10k_lean.omp.json)"
EOF

# Install cloud related packages
pacman -S --noconfirm kubectl krew helm k9s kubectx cilium-cli talosctl opentofu

# Set git configurations
git config --global init.defaultBranch main

# Create dev tools directory
mkdir -p /home/wsl/.devtools

# Install JS packages
pacman -S --noconfirm nodejs npm deno

# Change npm's default directory
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
mkdir /home/wsl/.devtools/npm-global
chown -R wsl:wsl /home/wsl/.devtools/npm-global
npm config set prefix "/home/wsl/.devtools/npm-global"
tee /home/wsl/.bashrc.d/npm << 'EOF'
export PATH=$HOME/.devtools/npm-global/bin:$PATH
EOF

# Install Python uv
pacman -S --noconfirm uv

tee /home/wsl/.bashrc.d/python << 'EOF'
# uv shell autocompletion
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
EOF

# Install Go
pacman -S --noconfirm go go-tools gopls
mkdir -p /home/wsl/.devtools/go
tee /home/wsl/.bashrc.d/go << 'EOF'
export GOPATH="$HOME/.devtools/go"
export PATH="$GOPATH/bin:$PATH"
EOF

# ssh-agent
# https://wiki.archlinux.org/title/SSH_keys#SSH_agents
tee /home/wsl/.bashrc.d/python << 'EOF'
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
EOF

# Make sure that all /home/wsl actually belongs to wsl
chown -R wsl:wsl /home/wsl