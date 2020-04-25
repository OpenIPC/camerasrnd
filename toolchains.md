# Toolchains

## Version Mapping of the Toolchains

| SDK Version               | Toolchain          |
| ------------------------- | ------------------ |
| Hi3516C V300R001C01SPC040 | arm-hisiv500-linux |
| Hi3516C V300R001C02SPC040 | arm-hisiv600-linux |

## Toolchain details

Used `crosstools-ng` params

| Toolchain | arm-hisiv500-linux | arm-hisiv600-linux | arm-himix100-linux |
|---|---|---|---|
| CT_TARGET_VENDOR | hisiv500 | hisiv600 | himix100 |
| CT_LIBC | CT_LIBC_UCLIBC | CT_LIBC_GLIBC | CT_LIBC_UCLIBC |
| CT_TOOLCHAIN_PKGVERSION | Hisilicon_v500_20170922 | Hisilicon_v600_20170615 | HC&C V100R002C00B032_20190114 |

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

### arm-hisiv500-linux
uClibc-based:


```sh
$ arm-himix100-linux-gcc -v
Using built-in specs.
COLLECT_GCC=arm-himix100-linux-gcc
COLLECT_LTO_WRAPPER=/opt/hisi-linux/x86-arm/arm-himix100-linux/host_bin/../libexec/gcc/arm-linux-uclibceabi/6.3.0/lto-wrapper
Target: arm-linux-uclibceabi
Configured with: /home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/src/gcc-6.3.0/configure --host=i386-redhat-linux --build=i386-redhat-linux --target=arm-linux-uclibceabi --prefix=/home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/install --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --with-gnu-as --with-gnu-ld --enable-languages=c,c++ --enable-shared --enable-lto --enable-symvers=gnu --enable-__cxa_atexit --disable-libatomic --disable-nls --enable-clocale=gnu --enable-extra-hisi-multilibs --with-sysroot=/home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/install/target --with-build-sysroot=/home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/install/target --with-gmp=/home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/obj/host-libs/usr --with-mpfr=/home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/obj/host-libs/usr --with-mpc=/home/sying/SDK_CPU_UNIFIED/build/script/arm-himix100-linux/arm_himix100_build_dir/obj/host-libs/usr --disable-libgomp --disable-libquadmath --disable-fixed-point --disable-libsanitizer --disable-libitm --enable-poison-system-directories --with-pkgversion='HC&C V100R002C00B032_20190114'
Thread model: posix
gcc version 6.3.0 (HC&C V100R002C00B032_20190114)
```
