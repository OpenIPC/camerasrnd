# Crosscompiling Micropython

## Dependencies

No

## Source

GitHub repo: https://github.com/micropython/micropython

## Instructions

```sh
$ cd mpy-cross
$ make
$ cd ../ports/unix
$ make submodules
$ make CROSS_COMPILE=arm-hisiv500-linux- deplibs
$ make CROSS_COMPILE=arm-hisiv500-linux- MICROPY_PY_FFI=0
```

## Known problems

To use FFI features you'll need to crosscompile libffi first accoring
[suggestion](https://forum.micropython.org/viewtopic.php?t=1648)
