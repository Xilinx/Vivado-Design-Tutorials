############################################################################
# Copyright 2020 Xilinx Inc.				                                		  
#    									   
# Licensed under the Apache License, Version 2.0 (the "License");           
# you may not use this file except in compliance with the License.          
# You may obtain a copy of the License at                                   
#                                                                           
# http://www.apache.org/licenses/LICENSE-2.0                                
#									    
# Unless required by applicable law or agreed to in writing, software       
# distributed under the License is distributed on an "AS IS" BASIS,         
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  
# See the License for the specific language governing permissions and       
# limitations under the License.					    
#############################################################################

xsct% program_flash -f boot.bin -pdi versal_fallback_wrapper.pdi -offset 0x0 -flash_type qspi-x8-dual_parallel
xsct% program_flash -f boot0001.bin -pdi versal_fallback_wrapper.pdi -offset 0x0020000 -flash_type qspi-x8-dual_parallel
xsct% program_flash -f boot0002.bin -pdi versal_fallback_wrapper.pdi -offset 0x0040000 -flash_type qspi-x8-dual_parallel