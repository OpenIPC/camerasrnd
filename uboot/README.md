# U-Boot stuff

## Links for helpful resources

[Original documentation](http://www.denx.de/wiki/view/DULG/U-Boot)

## Access to U-Boot

Make sure that `F - Hardware Flow Control : No  ` in `Serial port setup` in
`cOnfigure Minicom` if you use `Minicom`

Or use `screen` to set proper mode from command line:

```sh
screen /dev/ttyUSB0 115200 -crtscts
```

## U-Boot hangs while communicating with TFTP server

The issue was found on CV300 cameras with U-Boot 2010.06. Everything works fine
when use straight patchcord between camera and TFTP server but adding network
switch in the middle leads data transfers which never ends.

![](images/12attempts.png/?raw=true)
![](images/34attempts.png/?raw=true)

The root cause is described [in unaccepted
path](https://patchwork.ozlabs.org/patch/167085/). It turns out that in CV300
U-Boot has `CONFIG_SYS_HZ == 195312` that breaks timeouts in network stack.

Use
[patch](https://github.com/mrchapp/arago-da830/blob/master/recipes/u-boot/u-boot-omap3-psp/omap3evm/2.1.0.4/0006-Fix-for-timeout-issues-on-U-Boot.patch)
to make your own changes like:

```diff
-  NetSetTimeout (TftpTimeoutMSecs, TftpTimeout);
+  NetSetTimeout(TIMEOUT * CONFIG_SYS_HZ, TftpTimeout);
```

## Rebuilded U-Boot from SDK reads garbage on XM-based IPC EV200/EV300 series

This happens due to hardware issue, when producer doesn't use all lines between
flash IC and controller and it needs to be set in `Dual` mode rather than `Quad`.
Apply [patch](https://github.com/dimerr/stuff/blob/master/0001-uboot_xm_ev200_ev300.patch)
before U-Boot compilation to fix it.