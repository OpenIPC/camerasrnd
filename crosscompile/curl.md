# Crosscompiling Curl

## Dependencies

mbedTLS in case you need TLS support

## Source

Curl (7.70.0)

Home page: https://curl.haxx.se
Download: https://curl.haxx.se/download/curl-7.70.0.tar.xz

Home page: https://tls.mbed.org/
Download: https://tls.mbed.org/code/releases/mbedtls-2.16.6-gpl.tgz

## Instructions

```sh
# Download mbedTLS
MBEDDIR=$(pwd)/_insall
cmake -H. -Bbuild -DCMAKE_C_COMPILER=arm-hisiv500-linux-gcc \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_INSTALL_PREFIX=$MBEDDIR
cmake --build build --target install

# Download curl
CURLDIR=$(pwd)/_intall
./configure --host=arm-hisiv500-linux --prefix=$CURLDIR --without-ssl \
    --with-mbedtls=$MBEDDIR
make
make install
```
