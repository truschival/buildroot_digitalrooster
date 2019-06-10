#!/bin/bash

# Add Wifi Password to /etc/wpa_supplicant.conf if it exists
function update_wpa_config() {
    local WPA_SUPPLICANT_CFG_PATH=${TARGET_DIR}/etc/wpa_supplicant.conf
    local WIFI_NET_GUARD="# LOCAL_WIFI_NET_CFG updated by common/post_build.sh"
    local NETCONF=""

    if [ -e ${WPA_SUPPLICANT_CFG_PATH} ] && [ ! -z "${LOCAL_WIFI_NET_CFG}" ];
    then
	# Check if netconf file exists
	if [ ! -e ${LOCAL_WIFI_NET_CFG} ] ;
	then
	    echo "${LOCAL_WIFI_NET_CFG} not found"
	    return
	fi

	grep -q "${WIFI_NET_GUARD}" ${WPA_SUPPLICANT_CFG_PATH}
	if [ $? -eq 1 ];
	then
	    echo ${WIFI_NET_GUARD} >> ${WPA_SUPPLICANT_CFG_PATH}
	    cat < ${LOCAL_WIFI_NET_CFG} >> ${WPA_SUPPLICANT_CFG_PATH}
	else
	    echo "post_build.sh already modified ${WPA_SUPPLICANT_CFG_PATH} - not changing!"
	fi
    fi
}

echo "Updating WPA Supplicant config LOCAL_WIFI_NET_CFG=${LOCAL_WIFI_NET_CFG}"
update_wpa_config
