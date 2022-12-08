#!/bin/bash
ZIPNAME="out/target/product/juice/recovery.img"
ZIP=$(ls SHRP*.zip)

echo "TWRP: repo sync"
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="SHRP: repo sync"
mkdir twrp && cd twrp
repo init --depth=1 --no-repo-verify -u https://github.com/SHRP/manifest.git -b shrp-12.1 -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j16
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="SHRP: cloning device tree && build twrp."
git clone https://github.com/vsc-sxx/device_xiaomi_juice-twrp device/xiaomi/juice
source build/envsetup.sh
lunch twrp_juice-eng
mka recoveryimage ALLOW_MISSING_DEPENDENCIES=true # Only if you use minimal twrp tree.
rclone copy $ZIPNAME shelby:shrp -P
rclone copy $ZIP shelby:shrp -P
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="SHRP | Branch: shrp-12.1 | STATUS: TESTING | Device: juice"
