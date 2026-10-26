########################################
# © Copyright 2021 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
########################################
KERNEL=kmeans_top
IP=kmeans_ip_from_vitis_vck190/component.xml
ZIP=kmeans_ip_from_vitis_vck190/${KERNEL}.zip
ZUIP=kmeans_ip_from_vitis_zc1657/component.xml
ZUZIP=kmeans_ip_from_vitis_zc1657/${KERNEL}.zip
DEVICE_NAME=xcvc1902-vsva2197-2MP-e-S-es1
ZUDEVICE_NAME=xczu19eg-ffvb1517-2-i

TCLARGS=-tclargs ${DEVICE_NAME}
.PHONY: clean

all: ${IP}

zuplus: ${ZUIP}


${ZIP}: ../../hls/kmeans_vitis.cpp kmeans_hls_vck190.tcl
	vitis_hls -f kmeans_hls_vck190.tcl

${IP}:  ${ZIP}
	cd kmeans_ip_from_vitis_vck190; unzip ${KERNEL}.zip

${ZUZIP}: ../../hls/kmeans_vitis.cpp kmeans_hls_zc1657.tcl
	vitis_hls -f kmeans_hls_zc1657.tcl

${ZUIP}:  ${ZUZIP}
	cd kmeans_ip_from_vitis_zc1657; unzip ${KERNEL}.zip

clean:
	rm -rf vitis_hls.log *vck190 *zc1657 ${IP} ${ZIP}
