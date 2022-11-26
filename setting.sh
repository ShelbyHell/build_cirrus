echo "Configure github."
sudo apt update && sudo apt install git -y
git config --global user.name 'vsc-sxx.'
git config --global user.email "shelbyhell@proton.me"
git config --global credential.helper "cache --timeout=7200"

curl -s https://api.telegram.org/$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="Setup VM for building Kernel."
sudo apt-get update -q -y && sudo apt-get install -q -y --no-install-recommends \
    apt-utils apt-transport-https python3-apt \
    git ffmpeg maven nodejs ca-certificates-java pigz tar rsync rclone aria2 adb autoconf automake axel bc bison build-essential ccache lsb-core lsb-security ca-certificates systemd udev \
    git curl wget wput axel rsync \
    binutils coreutils bsdmainutils util-linux patchutils libc6-dev sudo \
    ssh openssl libssl-dev sshpass gnupg2 gpg \
    android-sdk-platform-tools adb fastboot squashfs-tools \
    openjdk-8-jdk ca-certificates-java \
    maven nodejs \
    python-all-dev python3-dev python3-requests \
    zip unzip lzip lzop zlib1g-dev xzdec xz-utils pixz p7zip-full p7zip-rar zstd libzstd-dev lib32z1-dev \
    build-essential gcc gcc-multilib g++ g++-multilib \
    clang llvm lld cmake automake autoconf \
    libxml2 libxml2-utils xsltproc expat re2c \
    ncurses-bin libncurses5-dev lib32ncurses5-dev bc libreadline-gplv2-dev libsdl1.2-dev libtinfo5 python-is-python2 ninja-build libcrypt-dev\
    file gawk xterm screen rename tree schedtool software-properties-common \
    dos2unix jq flex bison gperf exfat-utils exfat-fuse libb2-dev pngcrush imagemagick optipng advancecomp kmod gem ruby tmate

sudo apt install binutils-arm-none-eabi gcc-arm-none-eabi libstdc++-arm-none-eabi-newlib binutils-aarch64-linux-gnu gcc-aarch64-linux-gnu -y
