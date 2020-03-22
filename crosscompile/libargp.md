# Crosscompiling libargp

## Source

libargp is available from https://github.com/alexreg/libargp.

## Instructions

```sh
$ git clone https://github.com/alexreg/libargp
$ cd libargp
$ sed -i 's/configure\"/configure\" --host=arm-hisiv500-linux --prefix=\/opt\/hisi-linux\/x86-arm\/arm-hisiv500-linux\/usr/g' build
$ ./update-source
$ ./build
$ sudo cp gllib/libargp.a /opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr/lib
$ sudo cp include/argp.h /opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr/include
```
