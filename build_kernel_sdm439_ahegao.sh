#!/bin/bash
git clone https://github.com/RE800T/sunrise_kernel_sdm439 q-sdm439 && cd q-sdm439
clear
mkdir out
export ARCH=arm64
export O=out
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-none-eabi-
PATH="$PATH"
clang -v
aarch64-linux-gnu-ld.bfd -v && echo "test"

mkdir /tmp/output
ZIPNAME="/tmp/output/SunriseKernel-sdm439_$(date +%Y%m%d-%H%M).zip"

env() {
TRIGGER_SHA="$(git rev-parse HEAD)"
LATEST_COMMIT="$(git log --pretty=format:'%s' -1)"
COMMIT_BY="$(git log --pretty=format:'by %an' -1)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
KERNEL_VERSION="$(cat out/.config | grep Linux/arm64 | cut -d " " -f3)"
export FILE_CAPTION="
🏚️ Linux version: $KERNEL_VERSION
🌿 Branch: $BRANCH
🎁 Top commit: $LATEST_COMMIT
👩‍💻 Commit author: $COMMIT_BY"
}

env

compile() {
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": "@SunriseCI", "text": "Starting build SunriseKernel for sdm439", "disable_notification": true}' \
     https://api.telegram.org/bot$TG_TOKEN/sendMessage

make O=out sdm439-perf_defconfig
                      make -j16 O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-none-eabi-
}

zipping() {
   git clone -q https://github.com/ShelbyHell/AnyKernel3
   cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
   cd AnyKernel3
   zip -r9 "$ZIPNAME" * -x '*.git*' README.md *placeholder
   curl -F document=@"${ZIPNAME}" -F "caption=${FILE_CAPTION}" "https://api.telegram.org/bot${TG_TOKEN}/sendDocument?chat_id=${TG_CHAT_ID}&parse_mode=Markdown"
}

compile
zipping
