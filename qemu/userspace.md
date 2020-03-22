# Running ARM binaries on x86 host system

Straightforward example:

```
$ qemu-arm -L /srv/nfsroot sample_venc
[SAMPLE_VENC_Usage]-27: Usage : sample_venc <index>
[SAMPLE_VENC_Usage]-28: index:
[SAMPLE_VENC_Usage]-29: 	0) 720p classic H264 encode.
[SAMPLE_VENC_Usage]-30: 	1) 720p H264 encode with Title.
[SAMPLE_VENC_Usage]-31: 	2) 1*720p JPEG snap.
```

Your also can set `QEMU_LD_PREFIX` environment variable to emulated device
sysroot for more convenient use:

```
$ export QEMU_LD_PREFIX=/srv/nfsroot
```

## With rootfs using unpacked flash image from camera

```
$ sudo chroot nfsroot /bin/sh
```

## With rootfs based on Debian

```
$ sudo debootstrap --arch=armhf buster debarm
$ sudo cp /usr/bin/qemu-arm-static debarm/usr/bin

$ sudo mount -t proc proc     debarm/proc/
$ sudo mount -t sysfs sys     debarm/sys/
$ sudo mount -o bind /dev     debarm/dev/
$ sudo mount -o bind /dev/pts debarm/dev/pts
$ sudo chroot debarm /bin/echo "hello world"
```

Ideas were given from [article](https://ownyourbits.com/2018/06/13/transparently-running-binaries-from-any-architecture-in-linux-with-qemu-and-binfmt_misc/)
