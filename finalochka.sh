# Download ccache from shelby(rclone #1)
mkdir -p /tmp/ccache
rclone copy shelby:ccache/ccache.tar.gz /tmp -P
cd /tmp
time tar xf ccache.tar.gz
cd /tmp
###################

# Sync ROM(Cherish)
mkdir rom && cd /tmp/rom
repo init --depth=1 --no-repo-verify -u https://github.com/CherishOS/android_manifest.git -b tiramisu -g default,-mips,-darwin,-notdefault
git clone https://github.com/ShelbyHell/local_manifest .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8
###################

# Build ROM
export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
ccache -M 20G
ccache -o compression=true
ccache -z
. build/envsetup.sh
brunch juice
rclone copy /tmp/rom/out/target/product/juice/Cherish*.zip shelbyrezerv:cherish -P
###################

# Zipping ccache
cd /tmp
com ()
{
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}
time com ccache 1
rclone copy ccache.tar.gz shelby:ccache -P
###################
