#!/bin/bash

# Add Wifi Password to /etc/wpa_supplicant.conf if it exists
function update_wpa_config() {
    local WPA_SUPPLICANT_CFG_PATH=${TARGET_DIR}/etc/wpa_supplicant.conf
    local WIFI_NET_GUARD="# LOCAL_WIFI_NET_CFG updated by common/post_build.sh"
    local NETCONF=""
    echo ">Updating WPA Supplicant config LOCAL_WIFI_NET_CFG=${LOCAL_WIFI_NET_CFG}"

    if [ -e ${WPA_SUPPLICANT_CFG_PATH} ] && [ ! -z "${LOCAL_WIFI_NET_CFG}" ];
    then
	# Check if netconf file exists
	if [ ! -e ${LOCAL_WIFI_NET_CFG} ] ;
	then
	    echo " ${LOCAL_WIFI_NET_CFG} not found"
	    return
	fi
	grep -q "${WIFI_NET_GUARD}" ${WPA_SUPPLICANT_CFG_PATH}
	if [ $? -eq 1 ];
	then
	    echo ${WIFI_NET_GUARD} >> ${WPA_SUPPLICANT_CFG_PATH}
	    cat < ${LOCAL_WIFI_NET_CFG} >> ${WPA_SUPPLICANT_CFG_PATH}
	    echo " OK"
	else
	    echo " skipped (post_build.sh already modified ${WPA_SUPPLICANT_CFG_PATH})"
	fi
    fi
}

# Add ssh pubkey for root user
function update_root_ssh() {
    local SSH_AUTHORIZED_KEYS_PATH=${TARGET_DIR}/root/.ssh/authorized_keys
    echo ">Updating root ssh key $SSH_PUBKEY_FILE"
    # Check if a local pubkey is given and if it exists
    if [ ! -z "$LOCAL_SSH_PUBKEY" ] && [ -e $LOCAL_SSH_PUBKEY ] ;
    then
	mkdir -p  $(dirname $SSH_AUTHORIZED_KEYS_PATH)
	cat < $LOCAL_SSH_PUBKEY > $SSH_AUTHORIZED_KEYS_PATH
	chmod 600 $SSH_AUTHORIZED_KEYS_PATH
	echo " OK"
    else
	echo " skipped"
    fi
}


# Add /persistent to fstab
function update_fstab() {
    local FSTAB_PATH=${TARGET_DIR}/etc/fstab
    local FSTAB_PERSISTENT_GUARD="# Added by common/post_build.sh"
    local FSTAB_BOOT_ENTRY="/dev/mmcblk0p1	/boot	vfat    defaults        0       0"
    local FSTAB_PERSISTENT_ENTRY="/dev/mmcblk0p4	/persistent	ext4    defaults        0       0"

    echo ">Updating /etc/fstab"
    mkdir -p "${TARGET_DIR}/boot"

    grep -q "${FSTAB_PERSISTENT_GUARD}" ${FSTAB_PATH}
    if [ $? -eq 1 ];
    then
	echo ${FSTAB_PERSISTENT_GUARD} >> ${FSTAB_PATH}
	echo ${FSTAB_BOOT_ENTRY} >> ${FSTAB_PATH}
	echo ${FSTAB_PERSISTENT_ENTRY} >> ${FSTAB_PATH}
    else
	echo " skipped (post_build.sh already modified ${FSTAB_PATH})"
    fi
}

function set_version_info(){
    EXTERNAL_DIR="$(dirname $0)"
    GIT_DESC=$(git -C $EXTERNAL_DIR describe --dirty)
    echo ">Setting Version_info $GIT_DESC"
    local ts=$(date +%Y-%m-%d_%H:%M:%S)
    echo "REVISION=$GIT_DESC" >  ${TARGET_DIR}/etc/digitalrooster_build_info
    echo "BUILD_DATE=$ts"     >> ${TARGET_DIR}/etc/digitalrooster_build_info
}

update_wpa_config
update_fstab
set_version_info
update_root_ssh

##
# If a local environment variable for the public key certificate exists copy
# this file to the target root file system
##
if [ ! -z "$SWU_IMAGE_CERT_PATH" ] & [ -e "$SWU_IMAGE_CERT_PATH" ];
then
    # Install developer cert
    cp $SWU_IMAGE_CERT_PATH $TARGET_DIR/etc/swupdate/sw-update-cert.pem
fi
