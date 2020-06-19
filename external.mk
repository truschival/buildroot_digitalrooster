#include all External packages
include $(sort $(wildcard $(BR2_EXTERNAL_DigitalRooster_PATH)/package/*/*.mk))

# Post Image scripts to create SWU files
ifeq (y, $(BR2_DIGITALROOSTER_CREATE_SWU))

# Currently only for rpi0w
ifeq (y, $(BR2_DIGITALROOSTER_TARGET_RPI_ZERO_W))
BR2_ROOTFS_POST_IMAGE_SCRIPT+=\
	$(BR2_EXTERNAL_DigitalRooster_PATH)/board/rpi0w/gen_swupdate.sh
endif

endif

