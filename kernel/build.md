# Custom kernel build guide

## FAQ

### How to build kernel from source and apply patch from SDK

Navigate to `osdrv/opensource/kernel` directory of SDK and check in
`readme_en.txt` which proper vanilla kernel you will need to download from
`kernel.org`.

In particular case of `Hi3516CV300_SDK_V1.0.3.0` you will need to get
`v3.18.20` kernel:

```
wget -qO- \
    https://mirrors.edge.kernel.org/pub/linux/kernel/v3.x/linux-3.18.20.tar.xz \
    | tar xvfJ -
cd linux-3.18.20
patch -p1 < ../hi3516cv300_for_linux_v3.18.y.patch
ls -l arch/arm/configs/ | grep hi   # check all options
cp arch/arm/configs/hi3516cv300_full_defconfig .config
make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- \
    LOADADDR=0x80008000 -j$(nproc) uImage
```

`arm-hisiv500-linux-` is cross-tools prefix for your SDK.

At the end to need to check that you get something like this:

```
  UIMAGE  arch/arm/boot/uImage
Image Name:   Linux-3.18.20
Created:      Wed Feb 26 11:42:22 2020
Image Type:   ARM Linux Kernel Image (uncompressed)
Data Size:    2992152 Bytes = 2922.02 KiB = 2.85 MiB
Load Address: 80008000
Entry Point:  80008000
  Image arch/arm/boot/uImage is ready
```

### Test compiled kernel image

Place `uImage` to tftp directory of your TFTP server, reset camera and on
booting process press Ctrl-C to interrupt normal load process.

You will see something like this:

```
hi3516cv300 System startup

Uncompress.......Ok


hi3516cv300 System startup


U-Boot 2010.06-svn1098 (Jun 11 2018 - 13:17:42)

Check Flash Memory Controller v100 ... Found
SPI Nor(cs 0) ID: 0xef 0x40 0x17
spi_general_qe_enable(291): Error: Disable Quad failed! reg: 0x2
Block:64KB Chip:8MB Name:"W25Q64FV"
CONFIG_CLOSE_SPI_8PIN_4IO = y.
at hifmc100_setTB() mid:0xef,chipsize:0x800000 <no>.
lk[6 => 0x400000]
SPI Nor total size: 8MB
MMC:   
EMMC/MMC/SD controller initialization.
Card did not respond to voltage select!
No EMMC/MMC/SD device found !
In:    serial
Out:   serial
Err:   serial
Press Ctrl+C to stop autoboot
xmtech # <INTERRUPT>
xmtech #
```

In this example we use addresses `192.168.26.208` for camera and
`192.168.26.219` for TFTP server. Adjust them for your case and network
settings.

```
xmtech # setenv ipaddr 192.168.26.208
xmtech # setenv serverip 192.168.26.219
xmtech # tftp 0x82000000 uImage
Hisilicon ETH net controler
MAC:   00-12-17-B6-AE-4B
eth0 : phy status change : LINK=UP : DUPLEX=FULL : SPEED=100M
TFTP from server 192.168.26.219; our IP address is 192.168.26.208
Download Filename 'uImage'.
Download to address: 0x82000000
Downloading: #################################################
done
Bytes transferred = 2992216 (2da858 hex)
xmtech # bootm 0x82000000
## Booting kernel from Legacy Image at 82000000 ...
   Image Name:   Linux-3.18.20
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    2992152 Bytes = 2.9 MiB
   Load Address: 80008000
   Entry Point:  80008000
   Loading Kernel Image ... OK
OK

```

### U-Boot shows 'Starting kernel ...' and then hangs

In case of `3516cv300` board you might use convenient list of options to add
them into kernel config to get debug from UART console:

```
CONFIG_DEBUG_LL=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_LL_UART_PL01X=y
CONFIG_DEBUG_UART_PHYS=0x12100000
CONFIG_DEBUG_UART_VIRT=0x0
```

Add to `.config` and re-run `make` with same parameters.

In this example `0x12100000` got from chip datasheet as `The base address of
UART0 registers is 0x1210_0000`

### Get an error 'Error: unrecognized/unsupported machine ID'

Full possible output like

```
Error: unrecognized/unsupported machine ID (r1 = 0x00001f40).

Available machine support:

ID (hex)        NAME
ffffffff        Generic DT based system
ffffffff        Hisilicon Hi3516cv300 (Flattened Device Tree)
ffffffff        Hisilicon HiP04 (Flattened Device Tree)
ffffffff        Hisilicon HIX5HD2 (Flattened Device Tree)
ffffffff        Hisilicon Hi3620 (Flattened Device Tree)

Please check your kernel config and/or bootloader.
```

You have no Device tree files included for given hardware. You can use fresh
U-boot with included support for Device Tree files or just append Device tree
BLOB into kernel image. Use guide on page 11 of
[presentation](https://bootlin.com/pub/conferences/2014/elc/petazzoni-device-tree-dummies/petazzoni-device-tree-dummies.pdf)
with command like this:

```
cat arch/arm/boot/zImage arch/arm/boot/dts/myboard.dtb > my-zImage
mkimage ... -d my-zImage my-uImage
```

You might like to use simple build script to make all build steps and final
image copying like this:

```
make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- \
  -j$(nproc) zImage || exit 2

cat arch/arm/boot/zImage Hi3516CV300_DEMO_Board.dtb > my-zImage
/bin/sh ./scripts/mkuboot.sh -A arm -O linux -C none  -T kernel \
  -a 0x80008000 -e 0x80008000 -n 'devLinux-3.18.20' \
  -d my-zImage uImage
sudo mv uImage /srv/atftp/
```

### How to decompile extracted binary dtb file back to source code?

Use the same kernel `dtc` compiler, e.g.:

```
./scripts/dtc/dtc -I dtb -O dts -o Hi3516CV300_DEMO_Board.dts \
    Hi3516CV300_DEMO_Board.dtb
```

Or if `/sys/firmware/devicetree/base` directory is available on camera use
advice on p.15 of [presentation](https://bootlin.com/pub/conferences/2014/elc/petazzoni-device-tree-dummies/petazzoni-device-tree-dummies.pdf)

### Kernel hangs at "Uncompressing Linux... done, booting the kernel."

It seems you forgot pass proper console command line argument to kernel.

Try this:

```
setenv bootargs console=ttyAMA0,115200 panic=20 <other args>...
```

## Deal with original flash image

### How to backup full flash image without loading to U-Boot

Mount /utils directory to NFS server as usual:

```
mount -t nfs -o nolock serverip:/srv/nfs
```

and then

```
cd /utils
MAX=`ls -lr /dev/mtdblock* | head -1 | awk '{print $10}' | sed 's/[^0-9]*//g'`
echo -ne >ff.img
i=0
while [ "$i" -le "$MAX" ]; do
    echo "Dump $i part"
    cat /dev/mtdblock$i >> ff.img
    i=$((i+1))
done
sync
```

### How to mount original flash volumes with custom built kernel

Make sure that you have

```
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_ZLIB=n
CONFIG_SQUASHFS_LZO=n
CONFIG_SQUASHFS_XZ=y
```

kernel parameters enabled. Otherwise you will get messages like this:

```
List of all partitions:
1f00             192 mtdblock0  (driver?)
1f01            2944 mtdblock1  (driver?)
1f02            3072 mtdblock2  (driver?)
1f03            1408 mtdblock3  (driver?)
1f04             256 mtdblock4  (driver?)
1f05             320 mtdblock5  (driver?)
```

## Deal with NFS

To avoid too many device reboots and get smooth development experience it's
highly recommended at early stages use NFS as root volume. Make sure that you
have `CONFIG_ROOT_NFS` kernel parameter turned on.
