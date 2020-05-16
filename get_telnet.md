# How to login inside original firmware

Information applicable only for XM-based camera firmware.

## Enable telnet server

In U-Boot console:

```
setenv telnetctrl 1; saveenv
```

## Connect with telnet

```
LocalHost login: root
Password: xmhdipc
Welcome to HiLinux.
```

Also can try [other pairs](https://gist.github.com/gabonator/74cdd6ab4f733ff047356198c781f27d)

## Optional: enable Linux kernel verbose boot (where armbenv exists)

```
# armbenv -s xmuart 0
# reboot
```

Or in case where XmEnv exists:

```
# XmEnv -s xmuart 0
# reboot
```
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
