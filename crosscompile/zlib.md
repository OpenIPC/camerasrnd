# Crosscompiling ZLib

## Dependencies

No

## Source

Zlib (1.2.11) - 457 KB:

Home page: https://www.zlib.net/

Download: https://zlib.net/zlib-1.2.11.tar.xz

MD5 sum: 85adef240c5f370b308da8c938951a68

## Instructions

```sh
$ ./configure --prefix=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr
$ sudo make install
```

## Known problems

To allow build static and shared library at the same time [use instructions from
LFS project](http://www.linuxfromscratch.org/clfs/view/svn/ppc/final-system/zlib.html)
