#!/bin/bash
echo "TWRP: repo sync"
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="TWRP: repo sync"
mkdir twrp && cd twrp
repo init --depth=1 --no-repo-verify -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1 -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j16
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="TWRP: cloning device tree && build twrp."
git clone https://github.com/ShelbyHell/a31 device/samsung/a31
source build/envsetup.sh && lunch twrp_a31-eng && mka recoveryimage ALLOW_MISSING_DEPENDENCIES=true
ZIPNAME="out/target/product/a31/recovery.tar"
rclone copy $ZIPNAME shelby:twrp-a31 -P
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="TWRP | Branch: twrp-12.1 (for dt a10) | STATUS: TESTING | Device: a31"
