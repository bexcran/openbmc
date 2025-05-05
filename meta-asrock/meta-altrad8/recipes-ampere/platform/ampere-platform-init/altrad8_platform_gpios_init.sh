#!/bin/bash

function pre-platform-init() {
    echo "Do pre platform init"
}


function post-platform-init() {
    echo "Do post platform init"
}

export output_high_gpios_in_ac=(
    "i2c-backup-sel"
    "host0-shd-req-n"
    "host0-sysreset-n"
    "SYS_PWR_GD"
)

export output_low_gpios_in_ac=(
    "spi0-program-sel"
    "s0-rtc-lock"
    "host0-special-boot"
    "SYS_ATX_PSON_L"
)

export input_gpios_in_ac=(
    "s0-spi-auth-fail-n"
    "s0-vr-hot-n"
    "PS_PWROK"
)

export output_high_gpios_in_bmc_reboot=(
    "i2c-backup-sel"
)

export output_low_gpios_in_bmc_reboot=(
    "BMC_READY"
    "bmc-ok"
)

export input_gpios_in_bmc_reboot=(
    "BMC_SALT2_L"
)
