# Crosscompiling OpenSSL

## Dependencies

No

## Versions

Use `openssl-1.0.2l` for Hisilicon patch compatibility

## Source

Latest:

OpenSSL (1.1.1d) - 8,639 KB:

Home page: https://www.openssl.org/

Download: https://www.openssl.org/source/openssl-1.1.1d.tar.gz

MD5 sum: 3be209000dbc7e1b95bcdf47980a3baa

[Old releases](https://www.openssl.org/source/old/)

## More information

[Official Compilation and Installation on ARM](https://wiki.openssl.org/index.php/Compilation_and_Installation#ARM)

## Instructions

By default (without `shared` option in `./Configure` it's built as static
library).

```sh
$ export LOCAL_OPENSSL_DIR=$(pwd)
$ export CC=arm-hisiv500-linux-gcc
$ export AR=arm-hisiv500-linux-ar
$ export LD=arm-hisiv500-linux-ld
$ ./Configure --prefix=$LOCAL_OPENSSL_DIR/install shared linux-armv4
$ make build_crypto
```

## Build custom Hisilicon engine

```sh
$ vim +17 demos/engines/hisilicon/Makefile
```

Fix to `CFLAGS += -I$(EV200SDK)/drv/interdrv/cipher/include -I$(EV200SDK)/mpp/include` 
and add `LDFLAGS += -L$(EV200SDK)/mpp/lib` next line

```sh
$ make -C demos/engines/hisilicon gnu
$ make intall
$ cp demos/engines/hisilicon/libhisilicon.so install/lib/engines
```

## Known issue

Linking errors like this:

```sh
../libcrypto.a(x86_64cpuid.o): In function `OPENSSL_cleanse':
(.text+0x1a0): multiple definition of `OPENSSL_cleanse'
```

Make additional `make clean` just before `./Configure`. Courtesy of [SO](https://stackoverflow.com/questions/16488629/undefined-references-when-building-openssl)

## Benchmarks

### Without acceleration

```sh
# ./openssl speed aes-128-cbc aes-192-cbc aes-256-cbc

# cv300 plain
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
aes-128 cbc       8782.56k     9651.24k     9898.35k     9960.70k     9971.92k
aes-192 cbc       7585.03k     8269.25k     8417.72k     8491.35k     8500.57k
aes-256 cbc       6753.14k     7241.99k     7379.86k     7414.64k     7421.79k

# ev200 plain
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
aes-128 cbc      14043.98k    15148.14k    15562.92k    15593.72k    15627.40k
aes-192 cbc      12074.57k    12978.03k    13278.46k    13301.11k    13363.88k
aes-256 cbc      10676.81k    11381.65k    11546.79k    11590.59k    11649.02k

# ev300 plain
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
aes-128 cbc      14005.78k    15155.09k    15510.03k    15652.52k    15621.95k
aes-192 cbc      12083.39k    12976.05k    13240.05k    13344.09k    13322.21k
aes-256 cbc      10714.63k    11352.36k    11545.51k    11634.35k    11607.60k
```
