FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

EXTRA_OEMESON:append = " \
     -Dinsecure-tftp-update=disabled \
     -Dbmcweb-logging=enabled \
     -Dredfish-bmc-journal=enabled \
     -Dhttp-body-limit=65 \
     -Dvm-nbdproxy=enabled \
     -Dredfish-dump-log=enabled \
     "

SRC_URI += " \
            file://0001-Re-enable-vm-nbdproxy-for-Virtual-Media.patch \
            file://0002-Redfish-Add-message-registries-for-Ampere-event.patch \
            file://0003-Report-boot-progress-code-to-Redfish.patch \
            file://0004-LogService-Add-CPER-logs-crashdumps-to-FaultLog.patch \
            file://0005-LogService-Support-download-FaultLog-data-via-Additi.patch \
            file://0006-IntrusionSensor-patch-handler-and-IntrusionSensorReArm-support.patch \
            file://0007-Support-Redfish-Hostinterface-schema.patch \
            file://0008-Support-HostInterface-privilege-role.patch \
            file://0009-Check-HostName-valid-on-PATCH-operation.patch \
            file://0010-Redfish-add-message-registries-for-power-limit-event.patch \
            file://0011-Correct-the-service-and-path-of-PowerCap-D-Bus-inter.patch \
            file://0012-Disable-patching-to-IPv4Address-items-when-DHCP-is-enabled.patch \
            file://0013-Prevent-the-Operator-user-can-flash-the-firmware.patch \
           "
