# Buildroot External structure for DigitalRoosterGui

Buildroot external for creating a root file system running [DigitalRoosterGui](https://github.com/truschival/DigitalRoosterGui)
as digital alarm clock.

This repository is part of a larger project. For more information head to
[www.digitalrooster.dev](https://www.digitalrooster.dev)

## Supported hardware
The following extension boards for 'Raspberry Pi (Zero W)' or 'BananaPi M2 zero'
are configured:

-   Adafruit [PiTFT2.8" capacitive touch](https://learn.adafruit.com/downloads/pdf/adafruit-2-8-pitft-capacitive-touch.pdf)
-   Adafruit [Speaker Bonnet with MAX98357 I2S amp](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-speaker-bonnet-for-raspberry-pi.pdf)
-   Grayhill rotary encoder [61C11-01-08-02](http://lgrws01.grayhill.com/web1/images/ProductImages/I-21-22.pdf)
-   Texas Instruments BQ32000 Real time clock (after all its an alarm clock)

![DigitalRooster on hardware](./documentation/figs/Demo_on_hardware.jpg)

---

## License

Copyright 2018 by Thomas Ruschival <thomas@ruschival.de>

Licenced under the GNU PUBLIC LICENSE Version 2. The license terms can be found
in the file LICENSE

---
## Build Pre-requisites

-   [buildroot](https://buildroot.org/) installation
    `git clone git://git.buildroot.net/buildroot`

### Setup

``` sh
mkdir <build_tree>
make BR2_EXTERNAL=<local_clone_of_this_repo> -C<buildroot_installation_dir> \
     O=<build_tree> XXX_defconfig
cd <build_tree>
make menuconfig (optional)
```

**Tip:** in the build tree create a file ``local.mk`` where you can set
individual buildroot variables for your system like for instance the root
password. See [buildroot manual](https://buildroot.org/downloads/manual/manual.html#_advanced_usage)
Following example uses ccache, overrides the hostname, root password and
the source location for DigitalRoosterGui.

``` Makefile
BR2_CCACHE=y
BR2_CCACHE_DIR=$(HOME)/tmp/buildroot-ccache-bpim20
BR_CACHE_DIR=$(HOME)/tmp/buildroot-ccache-bpim20
BR2_TARGET_GENERIC_ROOT_PASSWD=foo
BR2_TARGET_GENERIC_HOSTNAME=bpim2zero
DIGITALROOSTERGUI_OVERRIDE_SRCDIR=/home/ruschi/Coding/DigitalRooster
```

### Target build configurations

Currently the following configurations (`XXX_defconfig`) for exist:
-   `rpi0w_defconfig` DigitalRooster on a Raspberry Pi Zero W
    (currently running at my bedside)

-   `bananapi_m2_zero_defconfig` DigitalRooster on a BananaPi M2 Zero
    ( *in development* )

## Environment variables

### Network configuration

``boards/common/post_build.sh`` has a hook to configure wifi network passwords.

Set the environment variable ``LOCAL_WIFI_NET_CFG`` to a file path containing
your wifi network configuration. The content of this file will be added
to ``/etc/wpa_supplicant.conf`` of your target filesystem.

### Example

``` sh
cd <build_tree>
cat ~/my_wifi_conf
network={
    ssid="my_wifi_network_ssid"
    psk=081937e670bxxxxxxxxxxxxxxxf63994c45ce2a43d
}

export LOCAL_WIFI_NET_CFG=~/my_wifi_conf
make
```

### Signed SWUpdate images

[SWUpdate](https://sbabic.github.io/swupdate/index.html) installed with
`rpi0w_defconfig` is configured to verify image signatures.  Once compiled with
signed image verification this feature is no longer optional.  This means if you
want to use sw-update images to update your DigitalRooster you have to create
signed images.

To do this you need a public certificate that is installed on DigitalRooster and
will be used by sw-update to verify your image. You will also need a private key
to sign your image.

These to files are passed to the build by two environment variables:
*  The variable `SWU_IMAGE_CERT_PATH` contains the path of the public
   certificate that will be installed in `/etc/ssl/certs/sw-update-cert.pem`
   used for validating signatures at runtime.
*  The environment variable `SWU_IMAGE_SIG_KEY_PATH` contains the path
   to a path of the private RSA key matching the public cert used for
   signing in the .swu file.

To create the key and the ceritficate follow the documentation of
[Update images from verified source](https://sbabic.github.io/swupdate/signed_images.html)
