setenv fdt_high ffffffff

setenv bootargs console=ttyS0,115200 fbcon=map:10 fbcon=font:VGA8x8 fbmem=2M earlyprintk root=/dev/mmcblk0p2 rootwait

fatload mmc 0 $kernel_addr_r zImage
fatload mmc 0 $fdt_addr_r digitalrooster-bananapi-m2-zero.dtb

bootz $kernel_addr_r - $fdt_addr_r
