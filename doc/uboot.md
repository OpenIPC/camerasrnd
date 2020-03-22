# Links for helpful resources

[Original documentation](http://www.denx.de/wiki/view/DULG/UBoot)

# Access to U-Boot

Make sure that `F - Hardware Flow Control : No  ` in `Serial port setup` in
`cOnfigure Minicom` if you use `Minicom`

Or use `screen` to set proper mode from command line:

```sh
screen /dev/ttyUSB0 115200 -crtscts
```
