# How to use modules to quickly debug driver changes

On example of `spi-nor` driver for `EV200` kernel

## Make code external module

* In `.config` set

    ```
    CONFIG_MTD_SPI_NOR=m
    CONFIG_SPI_HISI_SFC=m
    ```

  which will produce new kernel modules `spi-nor.ko` and `hisi-sfc.ko`

* Try to compile and find all unresolved symbols, find their definitions and
    prepend them with `EXPORT_SYMBOL`

* Compile again and make sure that the issue gone. Try to load new kernel and
    then load and unload both modules in appropriate order:

    ```
    insmod spi-nor.ko
    insmod hisi-sfc.ko
    rmmod hisi_sfc
    rmmod spi_nor
    ```

* In `rmmod hisi_sfc` you probably will get issue with backtrace messages in
  `dmesg`. Most likely it's double free issue as [described
  here](https://patchwork.kernel.org/patch/9270545/). I fixed it by commenting
  out line:

  ```c
  static int hisi_spi_nor_remove(struct platform_device *pdev)
    {
    	struct hifmc_host *host = platform_get_drvdata(pdev);
    
    	hisi_spi_nor_unregister_all(host);
    	//clk_disable_unprepare(host->clk);           // Double free?
    	return 0;
    }
  ```

* Test load/unload process again and you'll find that driver initialized only
  once (also check messages in `dmesg`). In my case I disabled all NAND drivers
  in kernel and moved `hifmc_cs_user` definition straight into
  `drivers/mtd/spi-nor/hisi-sfc.c` file.
