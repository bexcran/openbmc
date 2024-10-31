FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://com.adlink.Hardware.Chassis.Model.ComHpcAlt.json"

do_install:append() {
        install -m 0644 ${WORKDIR}/com.adlink.Hardware.Chassis.Model.ComHpcAlt.json ${D}${datadir}/phosphor-led-manager/
}
