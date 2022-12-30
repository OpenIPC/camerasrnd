# How to login inside original firmware

Information applicable only for XM-based camera (and partially DVR/NVR)
firmwares.

In recent versions of XM firmwares, telnet is not enabled by default,
and most of backdoors allowing to easily (remotely) enable it are
fixed/closed.

## Enable telnet server

In U-Boot console:

```
setenv telnetctrl 1; saveenv
```

Note that `saveenv` is mandatory, otherwise Linux side (which analyzes
this setting) simply won't see it.

## Connect with telnet

```
LocalHost login: root
Password: xmhdipc
Welcome to HiLinux.
```

Also can try [other login/passwd pairs](https://gist.github.com/gabonator/74cdd6ab4f733ff047356198c781f27d)
In recent NVR firmware versions, you may need to login with the actual
admin password which you set up in the UI (static predefined password
won't work).

## Optional: enable Linux kernel verbose boot

if armbenv exists

```
# armbenv -s xmuart 0
# reboot
```

Or in case where XmEnv exists:

```
# XmEnv -s xmuart 0
# reboot
```

Note that while this setting modifies U-Boot environment, it should be
done from Linux. At least some vendor U-Boot versions don't allow to
set this from U-Boot console itself (attempt to set a variable of such
name is ignored). But you can try with the -f option from U-Boot.

In U-Boot console:

```
setenv -f xmuart 0; saveenv
```

Note that `saveenv` is mandatory, otherwise Linux side (which analyzes
this setting) simply won't see it.

## Enable telnet without even open your camera (remotely)

* Find proper zip with recent firmware update using [link](https://translate.google.com/translate?hl=en&sl=ru&tl=en&u=https%3A%2F%2Fwww.cctvsp.ru%2Farticles%2Fobnovlenie-proshivok-dlya-ip-kamer-ot-xiong-mai) and download it.

* Unzip it and choose proper `bin` file from several options.

* It's recommended update your camera using this stock firmware without
    modifying it. It will help understand possible issues. Use `General...` if
    not sure which option you want.

* Unzip `bin` file as it would be ordinary zip archive.

* Copy `add_xmuart.sh` from `utils` directory of the repository inside directory
    with unpacked files.

* Run `./add_xmaurt.sh` and then ensure that `u-boot.env.img` has
    `xmuart=1telnetctrl=1` near the end of file.

* Repack `bin` file adding changed `u-boot.env.img` there like this: `zip -u General_IPC_HI3516EV200_85H30AI_S38.Nat.dss.OnvifS.HIK_V5.00.R02.20200507_all.bin u-boot.env.img`

* Upgrade camera using new `bin` file
