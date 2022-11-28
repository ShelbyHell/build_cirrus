#!/bin/bash
ZIPNAME="out/target/product/juice/recovery.img"

echo "TWRP: repo sync"
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="TWRP: repo sync"
mkdir twrp && cd twrp
repo init --depth=1 --no-repo-verify -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1 -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j16
echo "TWRP: cloning device tree & build twrp."
git clone https://github.com/vsc-sxx/device_xiaomi_juice-twrp device/xiaomi/juice
source build/envsetup.sh
lunch twrp_juice-eng
mka recoveryimage ALLOW_MISSING_DEPENDENCIES=true # Only if you use minimal twrp tree.
rclone copy $ZIPNAME shelby:twrp -P
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="TWRP 3.7.0 | Branch: twrp-12.1 | STATUS: TESTING | Device: juice
Owner please check your gdrive."