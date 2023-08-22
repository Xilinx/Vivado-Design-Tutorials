# Setting up variables needed to run this script
WORKING_DIR=$(pwd)
DESIGN_XSA=$WORKING_DIR/xsa/design.xsa
STATIC_XSA=$WORKING_DIR/xsa/static.xsa
RP1RM1_XSA=$WORKING_DIR/xsa/rp1rm1.xsa
RP1RM2_XSA=$WORKING_DIR/xsa/rp1rm2.xsa
RP1RM3_XSA=$WORKING_DIR/xsa/rp1rm3.xsa

cd $WORKING_DIR

# # Creating the PetaLinux project based on the BSP file and Versal template
petalinux-create -t project -n versal-dfx -s $WORKING_DIR/xilinx-vck190-v2022.2-10141622.bsp

cd $WORKING_DIR/versal-dfx

# The project needs the XSA file to know how to configure itself
petalinux-config --get-hw-description $DESIGN_XSA

# Configure the kernel, we want to go to:
# Device Drivers->Character devices->Serial drivers->Xilinx uartlite serial port support
# Change this setting to <M> (press spacebar twice)
petalinux-config -c kernel

# Blacklist uartlite driver in configuration file
cp $WORKING_DIR/code/petalinuxbsp.conf $WORKING_DIR/versal-dfx/project-spec/meta-user/conf/

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
mkdir ../../../sdcard
cp BOOT.BIN boot.scr image.ub rootfs.tar.gz ../../../sdcard
