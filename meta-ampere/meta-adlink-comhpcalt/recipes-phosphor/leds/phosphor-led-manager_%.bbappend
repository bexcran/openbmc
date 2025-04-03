FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://com.adlink.Hardware.Chassis.Model.ComHpcAlt.json \
             file://xyz.openbmc_project.LED.GroupManager.service"

DBUS_SERVICE:${PN} += "xyz.openbmc_project.LED.GroupManager.service"

do_install:append() {
        install -m 0644 ${WORKDIR}/com.adlink.Hardware.Chassis.Model.ComHpcAlt.json ${D}${datadir}/phosphor-led-manager/
}
