# Copyright 2021 Xilinx, Inc.
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

# "How to Round Numbers in Python" by Real Python, retrieved on 16 September 2021
# https://realpython.com/python-rounding/#rounding-half-up

import math
from chipscopy.api.ddr import DDR


def round_half_up(n, decimals=0):
    multiplier = 10 ** decimals
    return math.floor(n*multiplier + 0.5) / multiplier

def get_write_vref_range (ddr: DDR) : 
        default_wvref = ddr.ddr_node.get_property(['mgchk_def_wr_vref'])
        default_wrvref_code = default_wvref['mgchk_def_wr_vref']
        dwc_binary = f'{default_wrvref_code:06b}'
        range_bit = dwc_binary[0:1]
        return(range_bit)



def convert_vref_pct_to_code (ddr: DDR, mg_mode: str, req_vref="50") :


    ddr4_wrvref_0 = {60.0 : 0 , 60.65 : 1,  61.3 : 2 , 61.95 : 3 , 62.6 : 4,  63.25 : 5 , 63.9 : 6 , 64.55 : 7, 65.2 : 8, 65.85 : 9, 
                     66.5 : 10, 67.15 : 11, 67.8 : 12, 68.45 : 13, 69.1 : 14, 69.75 : 15, 70.4 : 16, 71.05 : 17, 71.7 : 18, 72.35 : 19,
                       73 : 20, 73.65 : 21, 74.3 : 22, 74.95 : 23, 75.6 : 24, 76.25 : 25, 76.9 : 26, 77.55 : 27, 78.2 : 28, 78.85 : 29,
                     79.5 : 30, 80.15 : 31, 80.8 : 32, 81.45 : 33, 82.1 : 34, 82.75 : 35, 83.4 : 36, 84.05 : 37, 84.7 : 38, 85.35 : 39, 
                       86 : 40, 86.65 : 41, 87.3 : 42, 87.95 : 43, 88.6 : 44, 89.25 : 45, 89.9 : 46, 90.55 : 47, 91.2 : 48, 91.85 : 49,
                     92.5 : 50 }
    
    ddr4_wrvref_1 = {45 : 0 , 45.65 : 1,  46.3 : 2 , 46.95 : 3 , 47.6 : 4,  48.25 : 5 , 48.9 : 6 , 49.55 : 7, 50.2 : 8, 50.85 : 9, 
                     51.5 : 10, 52.15 : 11, 52.8 : 12, 53.45 : 13, 54.1 : 14, 54.75 : 15, 55.4 : 16, 56.05 : 17, 56.7 : 18, 57.35 : 19,
                       58 : 20, 58.65 : 21, 59.3 : 22, 59.95 : 23, 60.6 : 24, 61.25 : 25, 61.9 : 26, 62.55 : 27, 63.2 : 28, 63.85 : 29,
                     64.5 : 30, 65.15 : 31, 65.8 : 32, 66.45 : 33, 67.1 : 34, 67.75 : 35, 68.4 : 36, 69.05 : 37, 69.7 : 38, 70.35 : 39, 
                       71 : 40, 71.65 : 41, 72.3 : 42, 72.95 : 43, 73.6 : 44, 74.25 : 45, 74.9 : 46, 75.55 : 47, 76.2 : 48, 76.85 : 49,
                     77.5 : 50 }

    lp4_wrvref_0 = {10.0 : 0 , 10.4 : 1,  10.8 : 2 , 11.2 : 3 , 11.6 : 4,  12 : 5 , 12.4 : 6 , 12.8 : 7, 13.2 : 8, 13.6 : 9, 
                    14.0 : 10, 14.4 : 11, 14.8 : 12, 15.2 : 13, 15.6 : 14, 16 : 15, 16.4 : 16, 16.8 : 17, 17.2 : 18, 17.6 : 19,
                      18 : 20, 18.4 : 21, 18.8 : 22, 19.2 : 23, 19.6 : 24, 20 : 25, 20.4 : 26, 20.8 : 27, 21.2 : 28, 21.6 : 29,
                      22 : 30, 22.4 : 31, 22.8 : 32, 23.2 : 33, 23.6 : 34, 24 : 35, 24.4 : 36, 24.8 : 37, 25.2 : 38, 25.6 : 39, 
                      26 : 40, 26.4 : 41, 26.8 : 42, 27.2 : 43, 27.6 : 44, 28 : 45, 28.4 : 46, 28.8 : 47, 29.2 : 48, 29.6 : 49,
                      30 : 50 }

    lp4_wrvref_1 = {22.0 : 0 , 22.4 : 1,  22.8 : 2 , 23.2 : 3 , 23.6 : 4,  24 : 5 , 24.4 : 6 , 24.8 : 7, 25.2 : 8, 25.6 : 9, 
                    26.0 : 10, 26.4 : 11, 26.8 : 12, 27.2 : 13, 27.6 : 14, 28 : 15, 28.4 : 16, 28.8 : 17, 29.2 : 18, 29.6 : 19,
                      30 : 20, 30.4 : 21, 30.8 : 22, 31.2 : 23, 31.6 : 24, 32 : 25, 32.4 : 26, 32.8 : 27, 33.2 : 28, 33.6 : 29,
                      34 : 30, 34.4 : 31, 34.8 : 32, 35.2 : 33, 35.6 : 34, 36 : 35, 36.4 : 36, 36.8 : 37, 37.2 : 38, 37.6 : 39, 
                      38 : 40, 38.4 : 41, 38.8 : 42, 39.2 : 43, 39.6 : 44, 40 : 45, 40.4 : 46, 40.8 : 47, 41.2 : 48, 41.6 : 49,
                      42 : 50 }

    wrvref_table = ddr4_wrvref_0
    
    if mg_mode == "READ" :

        ## READ VREF loookup
        read_vref_conv_unit = 0.000976563
        tmp = req_vref/100 / read_vref_conv_unit
        vref_code = int(round_half_up (tmp,0))
        print (f" Requested Read Vref %: {req_vref} actual % : {ddr.get_eye_scan_vref_percentage(vref_code)} " )
    elif mg_mode == "WRITE" :

        ## Write VREF lookup
        mem_type_property = ddr.ddr_node.get_property(['mem_type'])
        default_wvref = ddr.ddr_node.get_property(['mgchk_def_wr_vref'])
        default_wrvref_code = default_wvref['mgchk_def_wr_vref']
        dwc_binary = f'{default_wrvref_code:06b}'
        range_bit = dwc_binary[0:1]
                
       
        if mem_type_property['mem_type'] == 1 and range_bit == '0':  #DDR4
              wrvref_table = ddr4_wrvref_0
        elif mem_type_property['mem_type'] == 1 and range_bit == '1':  #DDR4
              wrvref_table = ddr4_wrvref_1
        elif mem_type_property['mem_type'] == 2 and range_bit == '0':  #LP4
              wrvref_table = lp4_wrvref_0
        elif mem_type_property['mem_type'] == 2 and range_bit == '1':  #LP4
              wrvref_table = lp4_wrvref_1
        else :
              print('Error in Write Vref Table decode')
              vref_code = -1
        
        # Find the Vref percentage value closest to the requested value
        closest_vref = min (wrvref_table, key=lambda x:abs(x-req_vref))
        print (f" Requested Write Vref %: {req_vref} closest % : {closest_vref}")
        vref_code = wrvref_table[closest_vref]

    else :
        print ('Invalid MARGIN_MODE variable provided, only READ or WRITE allowed')
        vref_code = -1

    return(vref_code)
