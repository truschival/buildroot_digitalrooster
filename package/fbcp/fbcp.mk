################################################################################
#
# FBCP
#
################################################################################

FBCP_VERSION = 32339651014fa2648d8a0278fdc059754a5cabc4
FBCP_SITE = https://github.com/truschival/rpi-fbcp.git
FBCP_SITE_METHOD = git

FBCP_INSTALL_STAGING = YES
FBCP_INSTALL_TARGET = YES
FBCP_LICENSE = GPL-2.0+


#install start script
define FBCP_POST_INSTALL_TARGET_SCRIPT
	cp $(BR2_EXTERNAL_DigitalRooster_PATH)/package/fbcp/S98fbcp.sh \
		${TARGET_DIR}/etc/init.d/
endef

FBCP_POST_INSTALL_TARGET_HOOKS += \
	FBCP_POST_INSTALL_TARGET_SCRIPT

$(eval $(cmake-package))
