# Crosscompiling Gettext

## Dependencies

No

## Source

Gettext (0.20.1) - 9,128 KB:

Home page: http://www.gnu.org/software/gettext/

Download: http://ftp.gnu.org/gnu/gettext/gettext-0.20.1.tar.xz

MD5 sum: 9ed9e26ab613b668e0026222a9c23639

## Instructions

```sh
$ ./configure --host=arm-hisiv500-linux --prefix=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr
$ make
$ sudo make install
```
