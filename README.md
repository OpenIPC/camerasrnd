# Research & Development repository about cheap cameras (mainly XM manufactured)

PRs with additional information and corrections are welcome.

## Supporting

If you like my work, help me to motivate myself to add new stuff here, please
consider supporting the project on Patreon. Thanks a lot!

<a href="https://www.patreon.com/widgetii"><img src="https://c5.patreon.com/external/logo/become_a_patron_button.png" alt="Patreon donate button" /> </a>

## FAQs

[How to get telnet on camera](get_telnet.md)

[Russian FAQ](doc/FAQ-ru.md). We need help to translate it to English (and I hope
to several popular languages too).

## Sophisticated usage

[YouTube streaming](streaming/youtube.md)

## Articles/books for newbies

- [George Hilliard - Mastering Embedded Linux, series of articles](https://www.thirtythreeforty.net/posts/2019/08/mastering-embedded-linux-part-1-concepts/)

- [Chris Simmonds - Mastering Embedded Linux Programming](https://books.google.com/books?id=4Hc5DwAAQBAJ&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false)

- [Bootlin Linux Kernel training materials](https://bootlin.com/doc/training/linux-kernel/linux-kernel-slides.pdf)

- [A book-in-progress about the linux kernel and its insides](https://0xax.gitbooks.io/linux-insides/content/index.html)

- [Alberto Liberal de los Ríos - Linux Driver Development for Embedded Processors - Second Edition](https://www.amazon.com/Linux-Driver-Development-Embedded-Processors-ebook/dp/B07L512BHG/)

- [Introducing ARM assembly language](http://www.toves.org/books/arm/)

## Telegram groups

[OpenIPC English](https://t.me/openipc)

[OpenIPC Russian, русская группа](https://t.me/joinchat/DJ_qFkdXU2CquZhdsVKlzg)

[OpenIPC Iranian, یم OpenIpc برای کاربران ایرانی](https://t.me/joinchat/EgJJ10_xsEGEL1pnV4kKig)

## Chip families information

Hardware structuring ([courtesy of OpenHisiIpCam project](https://github.com/OpenHisiIpCam/br-hisicam/blob/master/README.md#chip-families-information)):

| Chips                                              | shortcode   |
| -------------------------------------------------- | ----------- |
| hi3516av100, hi3516dv100                           | hi3516av100 |
| hi3519v101, hi3516av200                            | hi3516av200 |
| [hi3516cv100, hi3518cv100, hi3518ev100](https://drive.google.com/file/d/1XA5IqVb-mUvmYl_77TMnoNonvNgkq473/view) | hi3516cv100 |
| [hi3518cv200, hi3518ev200, hi3518ev201](https://drive.google.com/file/d/1nv-m7WFhhfAZ6xgynfZQh1ijtwmmf1UX/view) | hi3516cv200 |
| [hi3516cv300, hi3516ev100](https://drive.google.com/file/d/1xZf-YiYSmB8sn9Lnj3obsR-x4AqDPa4D/view) | hi3516cv300 |
| hi3516cv500, hi3516dv300, hi3516av300              | hi3516cv500 |
| [hi3516ev300](https://drive.google.com/file/d/1vjAQSrFoxioPq7OhL5taIyi2D0D_3WKc/view), [hi3516ev200](https://drive.google.com/file/d/1zGBJ_SIazFqJ8d8bguURVVwIvF4ybFs1/view), hi3516dv200, hi3518ev300 | hi3516ev200 |
| hi3519av100                                        | hi3519av100 |
| hi3559av100                                        | hi3559av100 |

If you know about newer versions of full datasheets or can share them for different
camera types don't hesitate to make a PR.

## Performance and sensors

| Chip | CPU | Encoder | JPEG substream | Sensors |
|---|---|---|---|---
| hi3516av100 | A7 600MHz | 5MP@30fps, 1080P@60fps, 1080P@30fps | 5MP@8fps | IMX178, IMX385, IMX290, IMX185, OV4689, AR0237
| hi3516dv100 | A7 600MHz | 5MP@15fps, 3MP@30fps, 1080P@30fps | 5MP@8fps | IMX178, IMX385, IMX290, IMX185, OV4689, AR0237
| hi3519v101 | A17 1.25GHz + A7 800MHz | 12MP@15fps, 8MP@30fps | 8MP@30fps | IMX226, IMX274
| hi3516av200 | A17 1.25GHz + A7 800MHz | 8@15fps, 6@30fps | 8MP@30fps | IMX274, OS08A10
| hi3516dv300 | A7 900MHz (NNIE 1.0Tops) | 5MP@20fps, 1080P@30fps | 16MP@10fps | IMX385, IMX327
| hi3516cv500 | A7 900MHz (NNIE 0.5Tops) | 3MP@20fps, 1080P@30fps | 16MP@10fps | IMX327
| hi3518ev200 | ARM926 540MHz | 720@30fps | 2MP@5fps | AR0130, OV9732, OV9712, F02
| hi3516ev100 | ARM926 800MHz | 1080@20fps | 2MP@5fps | IMX291, IMX323, SC3235
| hi3516cv300 | ARM926 800MHz | 1080@30fps | 2MP@5fps | IMX291, IMX323, SC3235
| hi3516ev300 | A7 900MHz | 4MP@15fps, 3MP@30fps | 4MP@5fps | IMX335
| hi3516ev200 | A7 900MHz | 3MP@20fps, 1080P@30fps | 3MP@5fps | SC3235, IMX307

![](images/hisilicon_families.jpg/?raw=true)

## Hardware

- [Sensors information](sensors/README.md)

### How to add new hardware support

[Your new ARM SoC Linux support check-list](https://elinux.org/images/a/ad/Arm-soc-checklist.pdf)

Official guides

| Topic | Document name | Date | Issue | Download |
| ----- | ------------- | ---- | ----- | -------- |


Sensor
Flash

## SDKs

### HiSilicon

| Family      | Kernel  | U-Boot            | MPP    |
| ----------- | ------- | ----------------- | ------ |
| hi3516av100 | 3.4.35  |                   | v2     |
| hi3516av200 | 3.18.20 |                   | v3     |
| hi3516cv100 | 3.0.8   | 2010.06-svn       | v1/v2? |
| hi3516cv200 | 3.4.35  |                   | v2     |
| hi3516cv300 | 3.18.20 | 2010.06-svn1098   | v3     |
| hi3516cv500 | 4.9.37  |                   | v4     |
| hi3516ev200 | 4.9.37  | 2016.11-g2fc5f58  | v4     |
| hi3516ev300 | 4.9.37  |                   | v4     |
| hi3519av100 | 4.9.37  |                   | v4     |
| hi3559av100 | 4.9.37  |                   | v4     |

HiSilicon SDK naming principles:

`Hi35xxVxxxRxxxCxxSPCxxy`

Each field is explained as follows:

* `Hi35xx`, segment contains chip type

* `Vxxx` segment contains the type of chip version

* `Rxxx` segment contains the release package type:

    - `R001`: Linux SDK

    - `R002`: Huawei LiteOS SDK

    - `R003`: Linux RDK reference design

    - other R bit is not used

* `Cxx` segment contains compiler specific environment

    - `C00`: FPGA-based

    - `C01`: type A compiler (e.g. `uclibc` based sysroot)

    - `C02`: type B compiler (e.g. `glibc` based sysroot)

    - `C03` and `C04` are reserved

    - `C05`: Huawei LiteOS

    - `C09`: based on Demo version

* `SPCxxy` segment shows current version

    `xx` for each next release will be incremented by 1 (releases with fixed errors,
    additional features, etc)

    `xx0` indicates normal version, for temporary versions last character could
    be incremented by 1 in range from `1-9` and `A-z`.

### XiongmaiTech

* [NetSDK](https://obs-xm-pub.obs.cn-south-1.myhuaweicloud.com/openPlat/20200227/NetSDK_20200227.zip)

* [NetSDK client example](https://github.com/dimerr/xmconfigtool)

[SDK archive](https://dl.openipc.org/SDK/) of OpenIPC project.

## Development

### Low level programming

* [ARM9EJ-S Technical Reference Manual](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0222b/DDI0222.pdf)

* [PrimeCell UART (PL011) Technical Reference Manual](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0183f/DDI0183.pdf)

### Cross-compilation

- [Known toolchains](toolchains.md)

- [Instructions for cross-compilation for different common
  software](crosscompile/index.md)

### Development using SDK

- [Building custom kernel](kernel/build.md)

- [Building Busybox](busybox/build.md)

- [Hacking camera using NFS](hacking/nfs.md)

### Debugging

- Debugging on board using gdbserver

- [Ltrace debug](debug/ltrace.md)

### Development tricks

- [Running ARM binaries using QEMU on dev host](qemu/userspace.md)

- [Changing files on readonly volumes](tricks/romounts.md)

### RE

- [Reverse binary Linux kernel](reverse/kernel.md)

- [Reverse HiTool](reverse/hitool.md)

- [Reverse Sofia](reverse/sofia.md)
