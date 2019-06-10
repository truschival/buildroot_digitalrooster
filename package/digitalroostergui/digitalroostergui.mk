################################################################################
#
# DigitalRoosterGui
#
################################################################################

ifeq (y , $(BR2_PACKAGE_DIGITALROOSTERGUI_VERSION_DEVEL))
	DIGITALROOSTERGUI_VERSION = develop
	DIGITALROOSTERGUI_SITE = https://github.com/truschival/DigitalRoosterGui.git
	DIGITALROOSTERGUI_SITE_METHOD = git
else
	DIGITALROOSTERGUI_VERSION = v0.7.1
	DIGITALROOSTERGUI_SOURCE = $(DIGITALROOSTERGUI_VERSION).tar.gz
	DIGITALROOSTERGUI_SITE = https://github.com/truschival/DigitalRoosterGui/archive
	DIGITALROOSTERGUI_SITE_METHOD = wget
endif

DIGITALROOSTERGUI_INSTALL_STAGING = YES
DIGITALROOSTERGUI_INSTALL_TARGET = YES
DIGITALROOSTERGUI_LICENSE = GPL-2.0+
DIGITALROOSTERGUI_LICENSE_FILES = LICENSE

DIGITALROOSTERGUI_CONF_OPTS += -DSYSTEM_TARGET_NAME=RPi

# build and install Unittests to target
ifeq (y , $(BR2_PACKAGE_WPA_SUPPLICANT))
	DIGITALROOSTERGUI_CONF_OPTS += -DHAS_WPA_SUPPLICANT=On
endif

# build and install Unittests to target
ifeq (y , $(BR2_PACKAGE_DIGITALROOSTERGUI_TEST))
	DIGITALROOSTERGUI_CONF_OPTS += -DBUILD_TESTS=ON -DBUILD_SHARED_LIBS=OFF

#install unit tests to target
define DIGITALROOSTERGUI_POST_INSTALL_UNIT_TEST_TO_TARGET

endef
endif # install unit tests

#install start script
define DIGITALROOSTERGUI_POST_INSTALL_TARGET_SCRIPT
	cp $(BR2_EXTERNAL_DigitalRooster_PATH)/package/digitalroostergui/S99digitalrooster.sh \
		${TARGET_DIR}/etc/init.d/
endef

DIGITALROOSTERGUI_POST_INSTALL_TARGET_HOOKS += \
	DIGITALROOSTERGUI_POST_INSTALL_TARGET_SCRIPT

$(eval $(cmake-package))
