# Building Busybox

```sh
cd $SDK_DIR/osdrv/opensource/busybox
tar xvf busybox-1.20.2.tgz
cd busybox-1.20.2
make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- defconfig
# use in case you need specify custom configuration for Busybox
# else just skip it:
make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- menuconfig
LDFLAGS="--static" make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- install CONFIG_PREFIX=./_rootfs
```

## Building Busybox-only rootfs (Rescue mode) <a name="rescue"></a>

```sh
pushd _rootfs
mkdir -p proc sys dev etc/init.d usr/lib new
cat <<EOF > etc/init.d/rcS
#!/bin/sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
mount -t proc none /proc
mount -t sysfs none /sys
/sbin/mdev -s
EOF
chmod +x etc/init.d/rcS 
popd

mksquashfs _rootfs busybox.squash -comp xz
# get filesize to use it later in kernel params
stat -c %s busybox.squash
sudo mv busybox.squash /srv/atftp
```
