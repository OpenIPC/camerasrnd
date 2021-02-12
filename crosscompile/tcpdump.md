# Crosscompiling Tcpdump

## Dependencies

Libnl

Libpcap

## Source



## Instructions

[Download](https://github.com/thom311/libnl/releases/download/libnl3_2_27/libnl-3.2.27.tar.gz)
and build libnl first (static version):

```sh
./configure CFLAGS="-static" --host=arm-hisiv500-linux \
    --prefix=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr
make && sudo make install
```

Build libpcap:

```sh
./configure --host=arm-hisiv500-linux \
    --prefix=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr \
    LDFLAGS=-L/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr/lib
make && sudo make install
```

Build tcpdump (static version):

```sh
./configure "CFLAGS=-pthread -lm" --host=arm-hisiv500-linux \
    --prefix=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr \
    LDFLAGS=-L/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr/lib
make && sudo make install
```
