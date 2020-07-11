# U-Boot stuff

## Links for helpful resources

[Original documentation](http://www.denx.de/wiki/view/DULG/U-Boot)

## Access to U-Boot console

Make sure that `F - Hardware Flow Control : No  ` in `Serial port setup` in
`cOnfigure Minicom` if you use `Minicom`

Or use `screen` to set proper mode from command line:

```sh
screen /dev/ttyUSB0 115200 -crtscts
```

## Compile your own version

Use `readme_en.txt` from SDK directory `osdrv` for reference.

### CV300

```sh
tar xvf u-boot-2010.06.tgz
cd u-boot-2010.06
# Find and copy mkboot.sh script
cp ../../../tools/pc/uboot_tools/mkboot.sh .
# Find and copy reg-init-table for CV300
cp $SOURCE_DIR/reg_info_hi3516cv300.bin .
# Apply fix for network issue
patch -p1 < CV300-Fix-network-broken-transfers.patch
# Compilation phase
make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- hi3516cv300_config
make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux-
# The generated u-boot.bin is copied to osdrv/tools/pc/uboot_tools/directory
./mkboot.sh reg_info_hi3516cv300.bin u-boot-ok.bin
# The generated u-boot-ok.bin is available for u-boot image
```

## Known issues

### U-Boot hangs while communicating with TFTP server

The issue was found on CV300 cameras with U-Boot 2010.06. Everything works fine
when use straight patchcord between camera and TFTP server but adding network
switch in the middle leads data transfers which never ends.

![](images/12attempts.png/?raw=true)
![](images/34attempts.png/?raw=true)

The root cause is described [in an unaccepted
patch](https://patchwork.ozlabs.org/patch/167085/). It turns out that in CV300
U-Boot has `CONFIG_SYS_HZ == 195312` that breaks timeouts in the network stack.

I used
[a patch](https://github.com/mrchapp/arago-da830/blob/master/recipes/u-boot/u-boot-omap3-psp/omap3evm/2.1.0.4/0006-Fix-for-timeout-issues-on-U-Boot.patch)
to make [my own patch](CV300-Fix-network-broken-transfers.patch) to fix the issue.

### Rebuilded U-Boot from SDK reads garbage on XM-based IPC EV200/EV300 series

This happens due to hardware issue, when producer doesn't use all lines between
flash IC and controller and it needs to be set in `Dual` mode rather than `Quad`.
Apply [patch](https://github.com/dimerr/stuff/blob/master/0001-uboot_xm_ev200_ev300.patch)
before U-Boot compilation to fix it.

## Tips and tricks

### CI tests against builded U-boot

I use small `build.sh` script which make build, reboots both USB UART adapter and IPC
itself, then upload fresh U-boot using `burn` tool via UART:

```sh
set -e

# In case of buggy USB UART adapter
sudo usbreset /dev/bus/usb/005/007

make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- -j$(nproc)
./mkboot.sh reg_info_hi3516cv300.bin u-boot-ok.bin
cp u-boot-ok.bin ~/git/burn

cd ~/git/burn
# Custom script to power reset camera via network switch
./restart_eth8.sh
./hi35xx-tool --chip hi3516cv300 --file=u-boot-ok.bin
screen /dev/ttyUSB0 115200
```

Sample workflow [is shown here](https://asciinema.org/a/felzD9YIwcD13lBewCaQe3XjK)
