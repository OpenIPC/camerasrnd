# Crosscompiling Libelf from Elfutils

## Dependencies

[Gettext](gettext.md)

[libargp](libargp.md)

[Zlib](zlib.md)

## Source

Elfutils (0.178) - 8,797 KB:

Home page: https://sourceware.org/ftp/elfutils/

Download: https://sourceware.org/ftp/elfutils/0.178/elfutils-0.178.tar.bz2

MD5 sum: 5480d0b7174446aba13a6adde107287f

## Instructions

```sh
$ ./configure --host=arm-hisiv500-linux \
    --prefix=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr \
    LDFLAGS=-L/opt/hisi-linux/x86-arm/arm-hisiv500-linux/usr/lib \
    --disable-debuginfod
```

Install only Libelf:

```sh
$ make -C libelf install
$ install -vm644 config/libelf.pc /usr/lib/pkgconfig
$ rm /usr/lib/libelf.a
```

## Known problems

`posix_fallocate` issue on uClibc:

```
Making all in libelf
  CC       elf_update.o
elf_update.c: In function ‘write_file’:
elf_update.c:98:4: error: implicit declaration of function ‘posix_fallocate’ [-Werror=implicit-function-declaration]
    if (unlikely (posix_fallocate (elf->fildes, 0, size) != 0))
    ^
```
