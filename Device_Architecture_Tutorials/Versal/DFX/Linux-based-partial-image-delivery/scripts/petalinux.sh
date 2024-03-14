#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

# Setting up variables needed to run this script
WORKING_DIR=$(pwd)
DESIGN_XSA=$WORKING_DIR/xsa/design.xsa
STATIC_XSA=$WORKING_DIR/xsa/static.xsa
RP1RM1_XSA=$WORKING_DIR/xsa/rp1rm1.xsa
RP1RM2_XSA=$WORKING_DIR/xsa/rp1rm2.xsa
RP1RM3_XSA=$WORKING_DIR/xsa/rp1rm3.xsa

# Creating the PetaLinux project based on the BSP file and Versal template
petalinux-create -t project -n versal-dfx -s $WORKING_DIR/xilinx-vck190-v2023.1-05080224.bsp

# To automate this script we want to skip past the  petalinx-config step in the manual version of this script since it requires user input, we are instead copying over the config file with everything pre-set
cp $WORKING_DIR/code/petalinux/config $WORKING_DIR/versal-dfx/project-spec/configs/

cd $WORKING_DIR/versal-dfx

#Using the switch --silentconfig will avoid bringing up the GUI
petalinux-config --get-hw-description $DESIGN_XSA --silentconfig

# Creating the static app
petalinux-create -t apps --template fpgamanager_dtg -n static-app --enable --srcuri "$STATIC_XSA"

# Create the rprm apps
petalinux-create -t apps --template fpgamanager_dtg_dfx -n rp1rm1-app --enable --srcuri "$RP1RM1_XSA" --static-pn static-app
petalinux-create -t apps --template fpgamanager_dtg_dfx -n rp1rm2-app --enable --srcuri "$RP1RM2_XSA" --static-pn static-app
petalinux-create -t apps --template fpgamanager_dtg_dfx -n rp1rm3-app --enable --srcuri "$RP1RM3_XSA" --static-pn static-app

# Create the libdfx app
petalinux-create -t apps -n libdfx-app --enable
cp -r $WORKING_DIR/code/libdfx/* $WORKING_DIR/versal-dfx/project-spec/meta-user/recipes-apps/libdfx-app/

# Build the project
petalinux-build

# Create the boot image and copy to SD card
cd $WORKING_DIR/versal-dfx/images/linux/
petalinux-package --boot --u-boot
mkdir $WORKING_DIR/sdcard
cp BOOT.BIN boot.scr image.ub rootfs.tar.gz $WORKING_DIR/sdcard
