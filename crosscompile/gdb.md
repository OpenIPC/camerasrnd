# Crosscompiling Gbb

## Source

## Instructions

### Build full Gdb package

```console
$ tar xvf gdb-9.1.tar.xz
$ mkdir build
$ cd build
$ ./configure --host=arm-buildroot-linux-uclibcgnueabihf
$ make
```

### Build only Gdbserver

```console
$ cd gdb-9.1/gdb/gdbserver
$ ./configure --host=arm-buildroot-linux-uclibcgnueabihf
$ make
```
