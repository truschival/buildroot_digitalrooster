#!/bin/sh

set -u
set -e
set -x

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi


# Install Framebuffer Console cmdline
for arg in "$@"
do
	case "${arg}" in
		--framebuffer-console)
			if ! grep  'fbcon=map:10' ${BINARIES_DIR}/rpi-firmware/cmdline.txt;
			   then
				   sed -i 's/rootwait/rootwait fbcon=map:10 fbcon=font:VGA8x8/g' \
					   ${BINARIES_DIR}/rpi-firmware/cmdline.txt
			fi
		;;
	esac
done

mkdir -p "${TARGET_DIR}/boot"

if ! grep -qE '^#---PiTFT---' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
	echo "Adding 'PiTFT Parameters' to config.txt (fixes ttyAMA0 serial console)."
	cat << __CONFIG_TXT_EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# fixes rpi3 ttyAMA0 serial console
dtoverlay=pi3-miniuart-bt
dtdebug=on

#---PiTFT---
dtparam=spi=on
dtparam=i2c1=on
dtparam=i2c_arm=on
dtoverlay=pitft28-capacitive,rotate=270,speed=34000000,fps=25,debug=1
#---end PiTFT---

#---- HDMI settings for 320x240 Framebuffer -----
hdmi_force_hotplug=1
max_usb_current=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt 320 240 60 6 0 0 0
hdmi_drive=1
#---- HDMI Display -----

#--- Speaker Bonnet
dtoverlay=hifiberry-dac
dtoverlay=i2s-mmap
#--- End SpeakerBonnet

#--- RTC
dtoverlay=i2c-rtc,pcf8523
#--- End RTC

#--- rotary encoder
dtoverlay=rotary-encoder
#--- end rotary

__CONFIG_TXT_EOF__
fi

#--- End PiTFT

##
# Add custom Device tree overlays to imges/rpi-firmware/overlays
##
cp -r ${BR2_EXTERNAL_DigitalRooster_PATH}/board/rpi0w/dt-overlays/* \
   ${BINARIES_DIR}/rpi-firmware/overlays
