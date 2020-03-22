# Dealing with readonly filesystem on camera

## mount -bind approach

In this example we override `etc` directory using ramdisk and `mount -bind`.
Make sure that you have enough memory. In case of shortage RAM you can use NFS
share for copying files.

```
$ mount | grep "type ramfs"
/dev/mem on /var type ramfs (rw,relatime)
/dev/mem2 on /utils type ramfs (rw,relatime)
$ cp -arv /etc/ /var
$ mount -o bind /var/etc /etc
$ passwd
Changing password for root
New password:
Retype password:
Password for root changed by root
$ cp /etc/passwd /etc/xmtelnetdpw
```

Now you can login via telnet using nonstandard root password.

## OverlayFS

Make sure that you're using kernel `3.18` version or upper

```
# insmod overlay.ko
# mkdir -p /tmp/upper /tmp/work
# mount -t overlay none \
    -o lowerdir=/mnt/custom,upperdir=/tmp/upper,workdir=/tmp/work /mnt/custom
# touch /mnt/custom/test
```
