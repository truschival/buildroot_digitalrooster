#!/bin/sh

# load WLAN Driver
modprobe brcmfmac
modprobe spi-bcm2835
modprobe i2c-bcm2708
modprobe bcm2708_fb fbwidth=320 fbheight=240 fbdepth=16 fbswap=1
modprobe evdev
# modprobe fb_hx8357d
# modprobe stmpe-ts
# modprobe gpio-backlight

# Capacitive Controller
modprobe edt-ft5x06

# light/gesture sensor
modprobe apds9960

# rotary encoder
modprobe rotary_encoder
