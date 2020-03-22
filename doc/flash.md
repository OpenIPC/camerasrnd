# Explore flash

## U-Boot commands

### SPI flash

`sf` just mounts the SPI flash. The only verb I can find is `sf probe` , which
seems to test for the presence of a device and/or make it available:

```
xmtech # sf probe 0
16384 KiB hi_fmc at 0:0 is now current device
xmtech # sf probe 1
16384 KiB hi_fmc at 0:1 is now current device
```

I use 'sf read' and it works pretty good. It can be called as follows
`sf read [addr] [offset] [len]`

So for your case, reading romfs would look like this:
`sf probe 0;sf read 0x82000000 0x40000 0x370000`

Then you can transfer the file to tftp server:
`tftp 0x82000000 romfs.cramfs 0x370000`

## Flash memory partitions layout

```sh
# cat /proc/mtd
dev:    size   erasesize  name
mtd0: 00030000 00010000 "boot"
mtd1: 00550000 00010000 "romfs"
mtd2: 00740000 00010000 "user"
mtd3: 00180000 00010000 "web"
mtd4: 00080000 00010000 "custom"
mtd5: 00140000 00010000 "mtd"

# ls -la /dev/mtdblock*
brw-------    1 root     root       31,   0 Jan  1  1970 /dev/mtdblock0
brw-------    1 root     root       31,   1 Jan  1  1970 /dev/mtdblock1
brw-------    1 root     root       31,   2 Jan  1  1970 /dev/mtdblock2
brw-------    1 root     root       31,   3 Jan  1  1970 /dev/mtdblock3
brw-------    1 root     root       31,   4 Jan  1  1970 /dev/mtdblock4
brw-------    1 root     root       31,   5 Jan  1  1970 /dev/mtdblock5

# mount |grep mtdblock
/dev/mtdblock2 on /usr type cramfs (ro,relatime)
/dev/mtdblock3 on /mnt/web type squashfs (ro,relatime)
/dev/mtdblock4 on /mnt/custom type cramfs (ro,relatime)
/dev/mtdblock5 on /mnt/mtd type jffs2 (rw,relatime)
/dev/mtdblock2 on /mnt/custom/data/Fonts type cramfs (ro,relatime)
```

Further [information](https://felipe.astroza.cl/hacking-hi3518-based-ip-camera/)
and some useful [in Russian](https://zftlab.org/pages/2018020100.html)
