# How to reverse binary Linux kernel

## Contents

- [Extract a piggy](#piggy)

- [Examine a procedure](#kallsyms)

- [Disable built-in driver](#disable-builtin)

## Extract a piggy <a name="piggy"></a>

The term `piggy` was originally used to describe a "piggy-back" concept. In this
case, the binary kernel image is piggy-backed onto the bootstrap loader to
produce the composite kernel image.

Recall that one of the common files built for every architecture is the ELF
binary named `vmlinux`. This binary file is the monolithic kernel itself, or
what we have been calling the `kernel proper`. In fact, when we looked at its
construction in the link stage of vmlinux, we pointed out where we might look to
see where the first line of code might be found. In most architectures, it is
found in an assembly language source file called `head.S` or similar.

```sh
$ make ARCH=arm CROSS_COMPILE=arm-hisiv500-linux- zImage
...   < many build steps omitted for clarity>
  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
  OBJCOPY arch/arm/boot/Image
  Kernel: arch/arm/boot/Image is ready
  AS      arch/arm/boot/compressed/head.o
  GZIP    arch/arm/boot/compressed/piggy.gzip
  AS      arch/arm/boot/compressed/piggy.gzip.o
  CC      arch/arm/boot/compressed/misc.o
  CC      arch/arm/boot/compressed/decompress.o
  AS      arch/arm/boot/compressed/debug.o
  CC      arch/arm/boot/compressed/string.o
  CC      arch/arm/boot/compressed/fdt_rw.o
  CC      arch/arm/boot/compressed/fdt_ro.o
  CC      arch/arm/boot/compressed/fdt_wip.o
  CC      arch/arm/boot/compressed/fdt.o
  CC      arch/arm/boot/compressed/atags_to_fdt.o
  AS      arch/arm/boot/compressed/lib1funcs.o
  AS      arch/arm/boot/compressed/ashldi3.o
  AS      arch/arm/boot/compressed/bswapsdi2.o
  LD      arch/arm/boot/compressed/vmlinux
  OBJCOPY arch/arm/boot/zImage
  Kernel: arch/arm/boot/zImage is ready
  Building modules, stage 2.
```

In the third line of listing, the `vmlinux` image (the kernel proper) is linked.
Following that, a number of additional object modules are processed. These
include `head.o`, `piggy.o`, and the architecture-specific among others.

| Component    | Function/Description                                                                                                                                                                                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `vmlinux`    | Kernel proper, in ELF format, including symbols, comments, debug info (if compiled with `-g`) and architecture-generic components.                                                                                                                                                     |
| `System.map` | Text-based kernel symbol table for `vmlinux module`.                                                                                                                                                                                                                                   |
| `Image`      | Binary kernel module, stripped of symbols, notes, and comments.                                                                                                                                                                                                                        |
| `head.o`     | ARM-specific startup code generic to ARM processors. It is this object that is passed control by the bootloader.                                                                                                                                                                       |
| `piggy.gz`   | The file `Image` compressed with gzip.                                                                                                                                                                                                                                                 |
| `piggy.o`    | The file `piggy.gz` in assembly language format so it can be linked with a subsequent object, `misc.o` (see the text).                                                                                                                                                                 |
| `misc.o`     | Routines used for decompressing the kernel image (`piggy.gz`), and the source of the familiar boot message: "Uncompressing Linux … Done" on some architectures.                                                                                                                        |
| `vmlinux`    | Composite kernel image. Note this is an unfortunate choice of names, because it duplicates the name for the kernel proper; the two are not the same. This binary image is the result when the kernel proper is linked with the objects in this table. See the text for an explanation. |
| `zImage`     | Final composite kernel image loaded by bootloader. See the following text.                                                                                                                                                                                                             |

In case of U-Boot based systems we need to go deeper and place the final
`zImage` into `uImage` file (with special header for U-Boot).

Simple algorithm to extract original `vmlinux` kernel suitable for reversing:

- Extract uImage (zImage with U-Boot header) from camera firmware. In my case best
  method to login to camera to upload `/boot/uImage` somewhere

- Use `binwalk -re uImage` to extract all useful data from the image

- Check all produced files using `strings` utility and special pattern from XM
  violated GPL code:

```sh
$ grep -rn xm_select_FlashProtMgr _uImage.extracted
Binary file _uImage.extracted/6000 matches
```

It's the `vmlinux` image from firmware.

- Build same version kernel with same toolchain as original with config as close
  to given hardware as possible, save `System.map` and `vmlinux`. You will need
  it as a `reference` to study sections and functions in `original` one.

- Open `reference` in your favorite disassembler, check first function start
  offset (in my case this is `0xC0008000`) and several opcodes from the
  beginning (`D3 F0 21 F3 10 9F 10 EE`):

  ![](images/IDA_reference_start.png?raw=true)

- Open `original` in your favorite disassembler. I like IDA, so let me show the
  example:

  1. Select `Processor type` as `ARM Little-endian [ARM]`

  2. Set `Loading offset` to `0xC0008000` (same number as found in previous step)

  3. `Do you want to change the processor type to ARM` -> `Yes`

  ![](images/IDA_original_load.png?raw=true)

  4. Select `Create RAM section` instead `Create ROM section` and copy-paste our
     suggested addresses as shown on image:

  ![](images/IDA_original_sections.png?raw=true)

  5. Wait while analysis runs. It will end when bottom bar will show `AU: idle`

  6. Check that you have same window as shown:

  ![](images/IDA_original_blob.png?raw=true)

  7. Type `C` and convert first instruction to assembly code

  8. Go to menu `Options` -> `General` and set `Number of opcode bytes` to `4`.

  9. Check out that you have same byte sequence as in `original` image:

  ![](images/IDA_original_opcodes.png?raw=true)

## Examine a procedure <a name="kallsyms"></a>

Use `/proc/kallsyms` to find address of concrete kernel symbol like this:

```sh
$ cat /proc/kallsyms | grep ' T ' | grep hisi_spi_nor_driver
```

While using IDA to inspect kernel code you can find ton of autogenerated subroutines
like `sub_C006758C` and due to absense of System.map it's near impossible to
understand what's going on. But most of the functions are opensourced and their
sources can be finded in original kernel source tree.

Use technique:

- find unknown subroutine like `C00CA1E4`

- grep same address in `/proc/kallsyms` (in lowercase)

- find name and rename subroutine to proper name

- repeat

TODO: write a script to mass-convert all kernel code to appropriate name (change
data type to code too and automark as subroutine).

## More automation

Write a program to check differences between original and opensource builded
kernels (w/o loaded modules) with filters on types (functions, structs and so
on).

## Disable built-in driver <a name=disable-builtin></a>

Advice was proposed on [SO](https://unix.stackexchange.com/a/474552/364571).

To do this, you'll need to add `initcall_blacklist=<driver_init>` as a kernel
boot option where `driver_init` is the driver initialization function - you'll
have to look through your kernel's sources to figure out what name needs to be
used. As a concrete example, `initcall_blacklist=hisi_spi_nor_driver_init` could
be used to blacklist internal flash driver on original kernel to test its some
opensource improvements.

| Driver     | Init entrypoint          | What was disabled        | Remark                                        |
| ---------- | ------------------------ | ------------------------ | --------------------------------------------- |
| hisi_spi   | hisi_spi_nor_driver_init | Disable SPI Flash driver |
| hisi-femac | hisi_femac_driver_init   | Disable Ethernet driver  |
| hibvt-i2c  | hibvt_i2c_driver_init    | Disable I2C driver       | Crash on `hi_piris.ko` module load w/o driver |
| himci      | himci_init               | Disable SD/eMMC driver   |
