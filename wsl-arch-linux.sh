# wsl -d ArchLinux

# Init and populate keyring
pacman-key --init
pacman-key --populate

# Configure mirrorlist
tee /etc/pacman.d/mirrorlist << 'EOF'
Server = https://europe.mirror.pkgbuild.com/$repo/os/$arch
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
EOF

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

# Install ZSH and dependencies
pacman -S --noconfirm zsh

# Change root password
passwd

# Setup user
useradd -m -G wheel -s /usr/bin/zsh wsl
passwd wsl
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Configure WSL
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#change-the-default-user-for-a-distribution
tee /etc/wsl.conf << 'EOF'
[boot]
systemd=true

[user]
default=wsl
EOF

# Create SSH directory and config file
mkdir -p /home/wsl/.ssh

chown 700 /home/wsl/.ssh

tee /home/wsl/.ssh/config << EOF
Host *
    ServerAliveInterval 60
EOF

# Create zsh configs directory
mkdir -p /home/wsl/.zshrc.d

# Configure ZSH
curl https://raw.githubusercontent.com/gjpin/arch-linux/main/configs/zsh/.zshrc -o /home/wsl/.zshrc

# Configure powerlevel10k zsh theme
curl https://raw.githubusercontent.com/gjpin/arch-linux/main/configs/zsh/.p10k.zsh -o /home/wsl/.p10k.zsh

# Install cloud related packages
pacman -S --noconfirm kubectl cilium-cli talosctl k9s opentofu

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
tee /home/wsl/.zshrc.d/npm << 'EOF'
export PATH=$HOME/.devtools/npm-global/bin:$PATH
EOF

# Install Python and create alias for python venv
pacman -S --noconfirm python
mkdir -p /home/wsl/.devtools/python
chown -R wsl:wsl /home/wsl/.devtools/python
python -m venv /home/wsl/.devtools/python/dev
tee /home/wsl/.zshrc.d/python << 'EOF'
alias pydev="source ${HOME}/.devtools/python/dev/bin/activate"
EOF

# Install Go
pacman -S --noconfirm go go-tools gopls
mkdir -p /home/wsl/.devtools/go
tee /home/wsl/.zshrc.d/go << 'EOF'
export GOPATH="$HOME/.devtools/go"
EOF

# Make sure that all /home/wsl actually belongs to wsl
chown -R wsl:wsl /home/wsl