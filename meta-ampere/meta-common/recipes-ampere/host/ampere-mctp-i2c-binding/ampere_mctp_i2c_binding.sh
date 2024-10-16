#!/bin/bash
#ampere_platform_config.sh is platform configuration file

# shellcheck disable=SC2046
# shellcheck source=meta-ampere/meta-common/recipes-ampere/platform/ampere-utils/utils-lib.sh
source /usr/sbin/utils-lib.sh

function s0_mctp_ready()
{
    retVal="1"
    output=$(i2cget -f -y 3 0x4f 0)
    ret=$?
    if [ $ret -eq 0 ]; then
        retVal="0"
    fi
    echo "$ret"
}

function s1_mctp_ready()
{
    retVal="1"
    state=$(gpioget $(gpiofind s1-pcp-pgood))
    if [ "$state" == "1" ]; then
        output=$(i2cget -f -y 3 0x4e 0)
        ret=$?
        if [ $ret -eq 0 ]; then
            retVal="0"
        fi
    fi
    echo "$retVal"
}

function s0_sensor_available()
{
    cnt=30
    retVal="1"
    while [ $cnt -gt 0 ];
    do
        state=$(busctl get-property xyz.openbmc_project.PLDM \
                /xyz/openbmc_project/sensors/temperature/S0_ThrotOff_Temp \
                xyz.openbmc_project.Sensor.Value Value)
        if [[ "$state" != "" ]]; then
            retVal="0"
            break;
        fi
        cnt=$(( cnt - 1 ))
        sleep 1
    done
    echo "$retVal"
}
function add_endpoints()
{
    cnt=20
    retVal="1"
    while [ $cnt -gt 0 ];
    do
        state=$(s0_mctp_ready)
        echo "add_endpoints s0_mctp_ready $state" >> /tmp/mctp_i2c_binding.log
        if [[ "$state" == "0" ]]; then
            output=$(busctl call xyz.openbmc_project.MCTP \
                /xyz/openbmc_project/mctp au.com.CodeConstruct.MCTP \
                SetupEndpoint say mctpi2c3 1 0x4f)
            ret=$?
            echo "add_endpoints create S0 MCTP DBus output $output ret $ret" >> /tmp/mctp_i2c_binding.log
            if [ $ret -eq 0 ]; then
                break;
            fi
        fi
        cnt=$(( cnt - 1 ))
        sleep 1
    done
    present=$(sx_present 1)
    echo "add_endpoints s1_present $present" >> /tmp/mctp_i2c_binding.log
    if [ "$present" == "0" ]; then
        state=$(s0_sensor_available)
        echo "add_endpoints s0_sensor_available $state" >> /tmp/mctp_i2c_binding.log
        if [[ "$state" == "0" ]]; then
            # wait for S1 mctp ready in 180 seconds
            cnt=180
            while [ $cnt -gt 0 ];
            do
                state=$(s1_mctp_ready)
                echo "add_endpoints s1_mctp_ready $state" >> /tmp/mctp_i2c_binding.log
                if [ "$state" == "0" ]; then
                    output=$(busctl call xyz.openbmc_project.MCTP \
                    /xyz/openbmc_project/mctp au.com.CodeConstruct.MCTP \
                    SetupEndpoint say mctpi2c3 1 0x4e)
                    ret=$?
                    echo "add_endpoints create S1 MCTP DBus output $output ret $ret" >> /tmp/mctp_i2c_binding.log
                    if [ $ret -eq 0 ]; then
                        break;
                    fi
                fi
                cnt=$(( cnt - 1 ))
                sleep 1
            done
        fi
        
    fi
}

function remove_endpoints()
{
    retVal="1"
    state=$(busctl call xyz.openbmc_project.MCTP \
            /xyz/openbmc_project/mctp/1/20 \
            au.com.CodeConstruct.MCTP.Endpoint Remove)
    ret=$?
    echo "remove_endpoints remove S0 MCTP DBus output $output ret $ret" >> /tmp/mctp_i2c_binding.log
    if [[ $ret -eq 0 ]]; then
        retVal="0"
    fi

    present=$(sx_present 1)
    echo "remove_endpoints s1_present $present" >> /tmp/mctp_i2c_binding.log
    if [ "$present" == "0" ]; then
        state=$(busctl call xyz.openbmc_project.MCTP \
                /xyz/openbmc_project/mctp/1/22 \
                au.com.CodeConstruct.MCTP.Endpoint Remove)
        ret=$?
        echo "remove_endpoints remove S1 MCTP DBus output $output ret $ret" >> /tmp/mctp_i2c_binding.log
        if [[ $ret -ne 0 ]]; then
            retVal="1"
        fi
    fi
    echo "$retVal"
}

if [ "$1" == "add_endpoints" ]; then
	echo "" >> /tmp/mctp_i2c_binding.log
	ret=$(add_endpoints)
elif [ "$1" == "remove_endpoints" ]; then
	ret=$(remove_endpoints)
fi

exit 0
