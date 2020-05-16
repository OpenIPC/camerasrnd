#!/bin/sh
#
# Add telnetctrl to u-boot unvironment
# sudo apt-get install u-boot-tools

origimg="u-boot.env.img"
tmpimg="u-boot.env.old"
rm ${tmpimg}
mv ${origimg} ${tmpimg}
rm env
rm u-boot.env
#

#dd bs=1 skip=68 if=${tmpimg} of=u-boot.env
tail -c+69 "${tmpimg}" > "u-boot.env"
loadaddr=$(mkimage -l ${tmpimg} | grep Load | awk {'print $3'})
entaddr=$(mkimage -l ${tmpimg} | grep Entry | awk {'print $3'})
cat u-boot.env | strings > env
echo "xmuart=1">> env
echo "telnetctrl=1">> env

imagesize=$(( 0x${entaddr} - 0x${loadaddr} ))
mkenvimage -s ${imagesize} -o u-boot.env env
mkimage -A arm -O linux -T firmware -n linux -a ${loadaddr} -e ${entaddr} -d u-boot.env u-boot.env.img

echo "Run:"
echo "zip -u General_IPC_HI3516EV300_85H50AI.Nat.dss.OnvifS.HIK_V5.00.R02.20200108_all.bin u-boot.env.img"
