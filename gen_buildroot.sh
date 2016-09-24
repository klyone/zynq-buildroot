#! /bin/bash

BUILDROOT="buildroot-2016.05"
CLEAN="x$1"

if [ ${CLEAN} == "xclean" ] ; then
	echo "Cleaning buildroot and SD files..."
	rm -rf buildroot
	rm -rf sd_card
fi

if [ ! -d buildroot ] ; then
	echo "Downloading ${BUILDROOT}..."
	wget https://buildroot.org/downloads/${BUILDROOT}.tar.gz > /dev/null
	tar xvf ${BUILDROOT}.tar.gz > /dev/null
	rm ${BUILDROOT}.tar.gz > /dev/null
	mv ${BUILDROOT} buildroot > /dev/null
	echo "Updating Buildroot configuration..."
	cp configs/buildroot/zybo.config buildroot/.config
	cp configs/buildroot/zybo.config buildroot/configs/zynq_zybo_defconfig
else
	echo "Omitting Buildroot download and configuration..."
fi

echo "Compiling Buildroot..."
cd buildroot
make
cd ..

echo "Generating SD files..."
if [ ! -d sd_card ] ; then
	mkdir sd_card
fi

cp buildroot/output/images/zynq-zybo.dtb sd_card/devicetree.dtb
cp buildroot/output/images/uImage sd_card
cp buildroot/output/images/rootfs.cpio.uboot sd_card/uramdisk.image.gz

echo "Warning: You have to put the BOOT.bin in the SD card too!"

echo "Done!"

