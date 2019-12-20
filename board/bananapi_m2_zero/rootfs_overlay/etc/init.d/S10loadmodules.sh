#!/bin/sh

# load WLAN Driver
modprobe brcmfmac
# modprobe bcm2708_fb fbwidth=320 fbheight=240 fbdepth=16 fbswap=1
modprobe evdev

# Capacitive Controller
modprobe edt-ft5x06

# light/gesture sensor
modprobe apds9960

# rotary encoder
modprobe rotary_encoder
