# How to login inside original firmware

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
