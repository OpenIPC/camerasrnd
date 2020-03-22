# Toolchains

## Version Mapping of the Toolchains

| SDK Version               | Toolchain          |
| ------------------------- | ------------------ |
| Hi3516C V300R001C01SPC040 | arm-hisiv500-linux |
| Hi3516C V300R001C02SPC040 | arm-hisiv600-linux |

## Toolchains details

### arm-hisiv500-linux

uClibc-based:

```sh
$ arm-hisiv500-linux-gcc -v
Using built-in specs.
COLLECT_GCC=arm-hisiv500-linux-gcc
COLLECT_LTO_WRAPPER=/opt/hisi-linux/x86-arm/arm-hisiv500-linux/bin/../libexec/gcc/arm-hisiv500-linux-uclibcgnueabi/4.9.4/lto-wrapper
Target: arm-hisiv500-linux-uclibcgnueabi
Configured with: ../gcc-linaro-4.9-2015.06/configure --host=x86_64-linux-gnu --build=x86_64-linux-gnu --target=arm-hisiv500-linux-uclibcgnueabi --prefix=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/arm-hisiv500-linux --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --with-arch=armv5te --with-gnu-as --with-gnu-ld --enable-languages=c,c++ --enable-shared --enable-lto --enable-symvers=gnu --enable-__cxa_atexit --enable-nls --enable-clocale=gnu --enable-extra-hisi-multilibs --with-sysroot=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/arm-hisiv500-linux/target --with-build-sysroot=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/arm-hisiv500-linux/target --with-gmp=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --with-mpfr=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --with-mpc=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --with-ppl=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --with-cloog=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --with-libelf=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --enable-libgomp --disable-libitm --disable-libsanitizer --enable-poison-system-directories --with-libelf=/home/sying/toolchain_ljhui/gcc4_9/arm-hisiv500-linux/gcc-uclibc/install/host_lib --with-pkgversion=Hisilicon_v500_20170922 --with-bugurl=http://www.hisilicon.com/cn/service/claim.html
Thread model: posix
gcc version 4.9.4 20150629 (prerelease) (Hisilicon_v500_20170922)
```

### arm-hisiv600-linux

Glibc-based:

```sh
$ arm-hisiv600-linux-gcc -v
Using built-in specs.
COLLECT_GCC=arm-hisiv600-linux-gcc
COLLECT_LTO_WRAPPER=/opt/hisi-linux/x86-arm/arm-hisiv600-linux/bin/../libexec/gcc/arm-hisiv600-linux-gnueabi/4.9.4/lto-wrapper
Target: arm-hisiv600-linux-gnueabi
Configured with: ../gcc-linaro-4.9-2015.06/configure --host=x86_64-linux-gnu --build=x86_64-linux-gnu --target=arm-hisiv600-linux-gnueabi --prefix=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/arm-hisiv600-linux --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --with-arch=armv5te --with-gnu-as --with-gnu-ld --enable-languages=c,c++ --enable-shared --enable-lto --enable-symvers=gnu --enable-__cxa_atexit --enable-nls --enable-clocale=gnu --enable-extra-hisi-multilibs --with-sysroot=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/arm-hisiv600-linux/target --with-build-sysroot=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/arm-hisiv600-linux/target --with-gmp=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --with-mpfr=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --with-mpc=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --with-ppl=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --with-cloog=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --with-libelf=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --enable-libgomp --disable-libitm --enable-poison-system-directories --with-libelf=/home/sying/toolchain_ljhui/gcc4_9/build-toolchain/gcc-glibc/install/host_lib --with-pkgversion=Hisilicon_v600_20170615 --with-bugurl=http://www.hisilicon.com/cn/service/claim.html
Thread model: posix
gcc version 4.9.4 20150629 (prerelease) (Hisilicon_v600_20170615)
```
