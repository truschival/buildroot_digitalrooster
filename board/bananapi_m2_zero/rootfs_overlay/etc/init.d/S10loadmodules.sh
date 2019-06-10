#!/bin/sh

# load WLAN Driver
modprobe brcmfmac
# modprobe bcm2708_fb fbwidth=320 fbheight=240 fbdepth=16 fbswap=1
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

#RTC - built in
# modprobe rtc-pcf8523

modprobe snd-soc-pcm512x
modprobe snd-soc-wm8804
#disable default audio snd-bcm2835
