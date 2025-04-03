FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

CFLAGS += "-Os -flto -ffunction-sections -fdata-sections -Wl,--gc-sections"
