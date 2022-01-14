# FAQ

This collection is compiled from messages found in Telegram channels `OpenIPC
software` and `OpenIPC modding`.

## Contents

### Original firmware

- [How to activate Telnet server?](#activate_telnet)

- [How to set password for Telnet?](#telnet_pwd)

- [How to deal with locked parameters in U-Boot?](#setenv)

- [What is Sofia?](#Sofia)

- [Is there any way to control camera using private Chinese protocol?](#netsdk)

- [How to encode sound for the camera?](#sound)

### Hacking

- [After killing Sofia camera reboots](#watchdog)

- [How to do a full-scale webcapture?](#fullcapture)

### Software

- [How to measure chip temperature?](#temperature)

### Hardware

- [What connector type to use for the board?](#jack)

- [Using PoE](#poe)

- [How does IR illumination works?](#ir)

- [How to use Ethernet from U-Boot?](#mii)

- [Why there is a sponge bush on lens?](#lenss)

---

## How to activate Telnet server? <a name="activate_telnet"></a>

The easiest way is to utilize any serial USB-UART adapter. You need to connect
it to camera's UART connector, reboot the device by power down, during boot
press Ctrl-C to reach U-Boot console, and enter command:

```
setenv telnetctrl 1; saveenv
```

Of course, this will require camera disassembly, a practice with serial console,
and wiring skills. Alternative method need no disassembly, but demand firmware
modification, hence it isn't suitable for novice users. It can be found
[here](https://github.com/OpenIPC/camerasrnd/blob/master/get_telnet.md).

## How to set password for Telnet? <a name="telnet_pwd"></a>


One can't do this with stock firmware. Yet, Telnet in XM camers can be considered
safe, except someone nasty will reach local network. Of course, all my installed
cameras have firmware modified and passwords changed. :)

(c) Dmitry Ermakov

## How to deal with locked parameters in U-Boot? <a name="setenv"></a>

Sometimes manufacturer locks certain parameters in U-Boot, i.e. on some XM
cameras one can't change `xmuart`. To unlock it I dump current parameters
using `printenv`, save results to file (env.txt), add my parameters there
(`xmuart=0`). Then command `mkenvimage -s 0x10000 -o u-boot.env.img env.txt`
converts parameters file to image, that can be loaded using `loady` or any
other way, which will alter env.

(c) Dmitry Ermakov

## What is Sofia? <a name="Sofia"></a>

This is thick executable file that contains _entire_ camera functionality
starting from DHCP client, till RTSP server and private control protocol.
Originally Chinese shamelessly copied all that from Dahua, where it was
called Sonia, now in XM cameras it became Sofia.

(c) Max

## Is there any way to control camera using private Chinese protocol? <a name="netsdk"></a>

There are some tools:

* [Python-DVR](https://github.com/NeiroNx/python-dvr), supports firmware updates

* [SofiaCtl](https://github.com/667bdrm/sofiactl)

* [DVRip](https://github.com/alexshpilkin/dvrip)

* [numenworld-ipcam](https://github.com/johndoe31415/numenworld-ipcam/blob/master/nwipcam)

* [NetSDK for C#](https://github.com/QuantMad/WinNetSDK)

## After `killall Sofia` camera reboots <a name="watchdog"></a>

One should unload watchdog kernel module, i.e. `rmmod xm_watchdog`.

(c) Sergey Sharshunov

## How to do a full-scale webcapture? <a name="fullcapture"></a>

Use the following:
```diff
--- ./orig/HI3516EV300_IPC_85H50AI_LIBXMCAP.json        2020-06-11 16:58:06.446462210 +0300
+++ ./HI3516EV300_IPC_85H50AI_LIBXMCAP.json     2020-06-11 21:45:16.978003244 +0300
@@ -230,8 +230,8 @@
                                "VencMode":
                                [
                                        {
-                                               "VpssChn": 2,
-                                               "EncCapSizeSrcs": ["HD1"],
+                                               "VpssChn": 1,
+                                               "EncCapSizeSrcs": ["720P"],
                                        }
                                ]
                        },
```
Now webcapture sends picture of 2592x1944, tested with EV300+IMX335.

(c) Dmitry Ermakov

## What is Crypto data?

That's XM cameras specific. Previously private settings (sensor type, run modes
table, MAC address) were stored in a separate Crypto-memory chip, hence the
name. Later, Crypto-memory was changed to EEPROM, and lately a dedicated chip
was removed, and all data was moved to the main flash storage.

The problem is, that if this information is lost (erased), then camera will
forget what it is. Ethernet card will drop to default MAC address, as well as
native soft will stop coding video, since it won't know the run mode. The
encryption algorithm is known, yet structure and contents remain a mystery.
The MAC address was located and there is description how to change it.

Before any experiments with firmware one can do configuration export using
CMS or IE. In resulting file locate `__tempinfo`, everything after that can be
deleted. This would be a backup copy of Crypto data, but one needs to subtract
9 from every byte to get magic value "D2 D4".

In flash memory Crypto is located in the last 1024 bytes of boot partition
(before env). Crypto's signature is 2 bytes 0xD2D4. Upon updating U-Boot for
another (i.e. the latest) version, there will be no way back. With U-Boot
flashed you will loose Crypto, which is stored at the very end of bootloader
before env. One needs to flash bootloader in such a way to keep Crypto, or
to make dedicated backup.

(c) Igor Zorin

> What uses Crypto data? Sofia?

One can say it happens before lauch of Sofia, because shared memory with HWID
is alreay initialized by kernel modules. And that memory contains main useful
information from Crypto to date.

There is a way to [generate Crypto data with new MAC address](https://github.com/nikitos1550/XM_ipcam_crypto_generator)
(tested with Hi3516cv100/Hi3518cv100).

## How to reset camera's password from Telnet?

Remove accounting data with:
`rm /mnt/mtd/Config/Account*`

## How to dump native firmware?

See advices [here (in Russian)](https://zftlab.org/pages/2018020100.html).

The method above doesn't work for new U-boot version 2016, which have firmware
dump functionality removed. See advice below.

## How to dump firmware from running system?

The system doesn't protect its own flash, so when you're inside, you can simply
read corresponding block devices with `cat /dev/mtdblock[x] > /tmp/mtdx` and
have entire image.

A script to build full flash image in one file:

```sh
mount -t nfs -o nolock serverip:/srv/nfs
cd /utils
MAX=$(ls -1r /dev/mtdblock* | head -n 1 | sed 's/[^0-9]*//g')
echo -ne >ff.img
i=0
while [ "$i" -le "$MAX" ]; do
    echo "Dump $i part"
    cat /dev/mtdblock$i >> ff.img
    i=$((i+1))
done
sync
```

The same, but saving partitions to separate files:

```sh
mount -t nfs -o nolock serverip:/srv/nfs
cd /utils
MAX=$(ls -1r /dev/mtdblock* | head -n 1 | sed 's/[^0-9]*//g')
i=0
while [ "$i" -le "$MAX" ]; do
    NAME=`grep mtd$i: /proc/mtd | awk '{gsub(/"/, "", $4); print $4}'`   
    echo "Dump $NAME"
    cat /dev/mtdblock$i >> $NAME.img
    i=$((i+1))
done
sync
```

## How to restore original firmware?

Find and download the latest firmware for your device. Full procedure is
described [here](https://www.cctvsp.ru/articles/vosstanovlenie-proshivki-i-sbros-parolya)
(in Russian, also with some links to firmware). Another good place to look for
firmware is [here](https://www.cctvsp.ru/articles/obnovlenie-proshivok-dlya-ip-kamer-ot-xiong-mai).

Long story short. Unpack firmware archive (usually it's a ZIP file internally)
and put resulting files on TFTP server. Connect the camera to network and run
commands:

```
setenv serverip 192.168.1.254; sf probe 0; sf lock 0; run dc; run dr; run du; run dw; reset
```

## How to measure chip temperature? <a name="temperature"></a>

This is very specific for each chip. Here are some known methods.

`Hi3516CV200 / Hi3518EV200 / Hi3518EV201`:
```sh
devmem 0x20270110 32 0x60FA0000 ; devmem 0x20270114 8  | awk '{print "CPU temperature: " ((($1)*180)/256)-40}'
```

`Hi3516CV300 / Hi3518EV100`:
```sh
devmem 0x1203009C 32 0x60FA0000 ; devmem 0x120300A4 16 | awk '{print "CPU temperature: " (((($1)-125.0)/806)*165)-40}'
```

`Hi3516EV200 / Hi3516EV300`:
```sh
devmem 0x120280B4 32 0xC3200000 ; devmem 0x120280BC 16 | awk '{print "CPU temperature: " (((($1)-117)/798)*165)-40}'
```

`Hi3536D`:
```sh
himm 0x0120E0110 0x60320000 > /dev/null; himm 0x120E0118 | awk '{print $4}' | dd skip=1 bs=7 2>/dev/null | awk '{print "0x"$1}' | awk '{print "CPU temperature: " (($1*180)/256)-40}'
```

`Hi3536CV100`:
```sh
himm 0x0120E0110 0x60320000 > /dev/null; himm 0x120E0118 | awk '{print $4}' | dd skip=1 bs=7 2>/dev/null | awk '{print "0x"$1}' | awk '{print "CPU temperature: " (($1-125)/806)*165-40}'
```

`HI3520DV200 `:
```sh
devmem 20060020 32
```

`Hi3516AV200`:
```sh
#PERI_PMC68 0x120a0110 (disable-->enable)
himm 0x120a0110 0 > /dev/null;
himm 0x120a0110 0x40000000 > /dev/null;

usleep 100000
#PERI_PMC70 0x120a0118 read temperature
DATA0=$(himm 0x120a0118 0 | grep 0x120a0118)
DATA1=$(printf "$DATA0" | sed 's/0x120a0118: //')
DATA2=$(printf "$DATA1" | sed 's/ --> 0x00000000//')

let "var=$DATA2&0x3ff"
if [ $var -ge 125 -a $var -le 931 ]; then
    echo `awk -v x="$var" 'BEGIN{printf "chip temperature: %f\n",(x-125)*10000/806*165/10000-40}'`
else
    echo "$var ---> invalid. [125,931]"
fi
```

## What connector type to use for the board? <a name="jack"></a>

Molex has nice `PicoBlade` series with 1.25mm pitch for camera's boards and with
2.0mm pitch for LED illumination. It is also known as `JST 1.25` at Ali/Tao,
which originates from Chinese manufacturer that copied PicoBlade (to be more
precise Japan company with factory in China). In fact Chinese shops sell
Ckmtw (Shenzhen Cankemeng) and HR (Joint Tech Elec). Original connectors
JST and Molex cost 10 times as Chinese compatible ones.

(c) Maxim Gatchenko

> Can I crimp those connectors myself?

Working crimper is enormously expensive, it is cheaper to buy cables directly.
If I need it real hard, I simply solder some wires, since crimper won't last for
long. If size allows, I press it a little and only then solder.

(c) Dmitry Ermakov

## How to enable DHCP during firmware update?

`echo 1 > /mnt/mtd/Config/dhcp.cfg`

One doesn't need to reboot the camera, since Sofia should take it on the fly and
store it for future use.

## How to reset all the setting to default?

Simply remove all files with setting using `rm -rf /mnt/mtd/*` and reboot.

## How to read encoder logs?

Ask camera to be more verbose:
```
echo "all=5" > /proc/umap/logmpp
```

Now simply read it all:
```
cat /dev/logmpp
cat /proc/umap/sys
cat /proc/umap/vi
cat /proc/umap/vpss
cat /proc/umap/venc
cat /proc/umap/logmpp
cat /proc/umap/isp
cat /proc/media-mem
```

If one needs it real-time:

```
echo "all=9" > /proc/umap/logmpp
cat /dev/logmpp
```

For a detailed description of data in those files read section `12 Proc
Debugging Information` from `HiMPP IPC V3.0 Media Processing Software
Development Reference` manual.

## How to mount jffs2 flash image on regular system?

```
sudo modprobe mtdram total_size=131072 erase_size=128
sudo modprobe mtdblock
sudo dd if=rootfs_hi3516cv300_128k.jffs2 of=/dev/mtdblock0
sudo mount -t jffs2 /dev/mtdblock0 /mnt
```

## How to encode sound for the camera? <a name="sound"></name>

```
sox input.mp3 -t al -r 8000 -c 1 -b 8 output.alaw
```

(с) Dmitry Ermakov

## Using PoE <a name="poe"></a>

I strongly advise to use 48V power adapters instead of 12V with RJ-45
connectors, since it is quite possible to damage connectors by high current.

## How does IR illumination works? <a name="ir"></a>

Actually IR light controls the camera instead of vice versa. When it becomes
dark enough in around for photosensor, IR LEDs are turned on and a dedicated
signal goes to camera, which in turn switches filter. To switch day/night
camera mode from this sensor, find setting "IR-filter" and change it to
"IR-sync" instead of "auto".

## How to use Ethernet from U-Boot? <a name="mii"></a>

Good introduction [article](https://gahcep.github.io/blog/2012/07/24/u-boot-mii/)
on the topic.

Please note, that the command `mii device` to U-Boot could result in empty list.
In this case try to ping _any_ address, this will initialize network device and
all should work after.

## Why there is a sponge bush on lens? <a name="lenss"></a>

It protects lens from extra light, one can make it using any type of sponge in
hand.

## How to use YouTube as DVR for your live video

Vasiliy, [21 Feb 2020 at 18:57:36]:
Here's the stuff:
1. You use ffmpeg to send video stream from camera to YouTube
2. But if there is no watchers, YouTube drops the stream
3. The upper limit for stream is 12 hours on YouTube (and one can benefit from
it!)
4. So YouTube begins recording if there is at least 1 watcher on channel and run
it for 30 minutes after last user stopped
5. There is a script that emulates 5 second watch and then YouTube continues to
run for another 30 minutes
6. You write to your crontab a command to get from
http://cloud.vixand.com/service/youtube/stream.php?key=ххххххххх and execute it
every 28 minutes
7. Profit

## Known problems

### After firmware update camera uses default MAC address and reboots constantly

Exploring camera with Telnet shows that `Sofia` is stopped, and even crashes
after manual launch:

```
CMedia::start() $Rev: 972 $>>>>>
sched set 98, 2
src/HiSystem.c(1461) [HisiSysInit]: LibHicap Compiled Date: Nov 26 2018, Time: 15:49:09.
src/HiSystem.c(1474) [HisiSysInit]: g_stDevParam.bVpssOnline:0 [0 offline; 1 online].
Segmentation fault
```

Using strace to have a closer look on`Sofia` we find:

```
open("/mnt/mtd/Config/SensorType.bat", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 ENOENT (No such file or directory)
--- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_MAPERR, si_addr=0x48} ---
+++ killed by SIGSEGV +++
Segmentation fault
```

It turns out that partition /mnt/mtd isn't mounted:

```
$ mount|grep /mnt/mtd
```

Trying to mount it manually:

```
$ mount -t jffs2 /dev/mtdblock5 /mnt/mtd
mount: mounting /dev/mtdblock5 on /mnt/mtd failed: Input/output error
```

And  dmesg` is full of something like:

```
fs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000000: 0xd4c5 instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000004: 0x3f7c instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000008: 0x37fc instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0000000c: 0x5d6b instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000010: 0xc45b instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000014: 0x9a6f instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000018: 0x80df instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0000001c: 0x7cb7 instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000020: 0xf5cd instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000024: 0xe587 instead
jffs2: Further such events for this erase block will not be printed
jffs2: Old JFFS2 bitmask found at 0x00001ee4
```

This partition is damaged, the solution is to erase it completely and fill it with 0xff. See next question.

(с) Dmitry Ermakov

### How to erase partition on flash

Check  /proc/cmdline` to find out partition size:

```
# cat /proc/cmdline
init=linuxrc mem=56M console=ttyAMA0,115200 root=/dev/mtdblock1 rootfstype=squashfs mtdparts=hi_sfc:0x30000(boot),0x2E0000(romfs),0x300000(user),0x160000(web),0x40000(custom),0x50000(mtd)
```

For our "mtd" partition `0x50000` is the correct value.

Now need to calculate start address. Given 8Mb flash size (0x800000) and taking
"mtd" partition to be the last one, we calculate offset as `0x800000-0x50000 = 0x7b0000`.

Now get to U-Boot and execute command `sf probe 0; sf lock 0; sf erase 7b0000
50000` to erase weird partition content.

(с) Dmitry Ermakov

If you can reach kernel boot log, it actually prints calculated addresses for
partitions:

```
[    0.813360] Creating 5 MTD partitions on "hi_sfc":
0x000000000000-0x000000080000 : "boot"
0x000000080000-0x0000000c0000 : "env"
0x0000000c0000-0x0000004c0000 : "kernel"
0x0000004c0000-0x0000009c0000 : "rootfs"
0x0000009c0000-0x000001000000 : "rootfs_data"
```

(c) Sergey Sharshunov

If you don't have access to U-Boot (got Telnet, but no UART), you can build
`flash_eraseall` using SDK `package/board_uclibc` and then erase partition
with command `/utils/flash_erase /dev/mtd5 0 0`, where`/dev/mtd5` is partition
name you determined earlier.
