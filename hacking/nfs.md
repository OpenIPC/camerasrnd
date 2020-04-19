# NFS

## Dump camera rootfs from flash to NFS server

Create separate exported NFS folder on your server like `/srv/cv300`, mount it
to empty dir (`/utils` in our example) and copy directories:

```sh
cp -a /bin /utils/
cp -a /boot /utils/
cp -a /etc /utils/
cp -a /home /utils/
cp -a /lib /utils/
cp -a /linuxrc /utils/
cp -a /mnt /utils/
cp -a /opt /utils/
cp -a /root /utils/
cp -a /sbin /utils/
cp -a /usr /utils/
cp -a /var /utils/

mkdir /utils/dev
mkdir /utils/proc
mkdir /utils/sys
mkdir /utils/tmp
```

Goto U-Boot and change params like this:

```
setenv bootargs ip=192.168.26.178 root=/dev/nfs nfsroot=192.168.26.219:/srv/cv300 init=/linuxrc mem=\${osmem} console=ttyAMA0,115200 panic=20
```

If you have error message like this after kernel loads, that your original
kernel doesn't support NFS root. Let's try workaround with initramfs:

## Workaround absent NFS support in original kernel

Navigate to new NFS root made in previous step and copy `/boot/uImage` to your
tftp server. Fell free to rename file for simplifying usage (like
`uImage.cv300` in our example).

Build special Busybox version (like [Rescue mode](../busybox/build.md), but with
modified `/etc/init.d/rcS` file):

```sh
cat <<EOF > etc/init.d/rcS
#!/bin/sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
echo "Waiting for network..."
sleep 5
mount -t nfs -o nolock 192.168.26.219:/srv/cv300 /new
cp /sbin/mdev /new/sbin/
mkdir -p /new/mnt/old_root/
pivot_root /new /new/mnt/old_root/
mount -t proc none /proc
mount -t sysfs none /sys
/etc/init.d/dnode
/sbin/mdev -s

# original firmware init code substitution from /etc/init.d/rcS
mount -t ramfs  /dev/mem  /var/
mkdir -p /var/tmp
# skipped net
mkdir -p /mnt/mtd/Config /mnt/mtd/Log /mnt/mtd/Config/ppp /mnt/mtd/Config/Json
ulimit -s 4096
/usr/etc/loadmod
# dvrHelper /lib/modules /usr/bin/Sofia 127.0.0.1 9578 1 &
EOF
```

Use U-Boot to temporary load dev environment (adjust `mem` param to your actual
board):

```
setenv bootargs mem=56M console=ttyAMA0,115200 panic=20 root=/dev/ram0 ro initrd=0x81220000,626688 rdinit=/bin/sh ip=192.168.26.178:192.168.26.1:192.168.26.1:255.255.255.0:camera1::off\\;

setenv ipaddr 192.168.26.178
setenv serverip 192.168.26.219
tftp 0x82000000 uImage.cv300
tftp 0x81220000 busybox.squash
bootm 0x82000000
```

where:

 - `626688` is a determined on previous step size of squashfs ramdisk image

 - `192.168.26.178` static camera IP

 - `192.168.26.219` NFS server (also the same address as TFTP server in our
     example)

 - `192.168.26.1` default gw
