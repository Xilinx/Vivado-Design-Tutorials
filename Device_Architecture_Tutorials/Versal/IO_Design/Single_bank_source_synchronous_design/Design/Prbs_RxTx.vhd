---------------------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /
-- \   \   \/    � Copyright 2015 Xilinx, Inc. All rights reserved.
--  \   \        This file contains confidential and proprietary information of Xilinx, Inc.
--  /   /        and is protected under U.S. and international copyright and other
-- /___/   /\    intellectual property laws.
-- \   \  /  \
--  \___\/\___\
--
---------------------------------------------------------------------------------------------
-- Device:              Ultrascale
-- Author:              Defossez
-- Entity Name:         Prbs_RxTx
-- Purpose:             PRBS generator and checker
--                Set parameters to the following values for a ITU-T compliant PRBS
---             -----------------------------------------------------------------------------
--              POLY_LENGHT POLY_TAP INV_PATTERN  || nbr of   bit seq.   max 0      feedback   
--                                                || stages    length  sequence      stages  
---             ----------------------------------------------------------------------------- 
--                  7          6       false      ||    7         127      6 ni        6, 7   
--                  9          5       false      ||    9         511      8 ni        5, 9   
--                 11          9       false      ||   11        2047     10 ni        9,11   
--                 15         14       true       ||   15       32767     15 i        14,15   
--                 20          3       false      ||   20     1048575     19 ni        3,20   
--                 23         18       true       ||   23     8388607     23 i        18,23   
--                 29         27       true       ||   29   536870911     29 i        27,29   
--                 31         28       true       ||   31  2147483647     31 i        28,31              
--              i=inverted, ni= non-inverted
--
-- Tools:               Vivado_2015.1 or later
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             
-- Filename:            Prbs_RxTx.vhd
-- Date Created:        May 2015
-- Date Last Modified:  May 2015
---------------------------------------------------------------------------------------------
-- Disclaimer:
--		This disclaimer is not a license and does not grant any rights to the materials
--		distributed herewith. Except as otherwise provided in a valid license issued to you
--		by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
--		ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
--		WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
--		TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
--		PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
--		negligence, or under any other theory of liability) for any loss or damage of any
--		kind or nature related to, arising under or in connection with these materials,
--		including for any direct, or any indirect, special, incidental, or consequential
--		loss or damage (including loss of data, profits, goodwill, or any type of loss or
--		damage suffered as a result of any action brought by a third party) even if such
--		damage or loss was reasonably foreseeable or Xilinx had been advised of the
--		possibility of the same.
--
-- CRITICAL APPLICATIONS
--		Xilinx products are not designed or intended to be fail-safe, or for use in any
--		application requiring fail-safe performance, such as life-support or safety devices
--		or systems, Class III medical devices, nuclear facilities, applications related to
--		the deployment of airbags, or any other applications that could lead to death,
--		personal injury, or severe property or environmental damage (individually and
--		collectively, "Critical Applications"). Customer assumes the sole risk and
--		liability of any use of Xilinx products in Critical Applications, subject only to
--		applicable laws and regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-- Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
---------------------------------------------------------------------------------------------
-- Revision History:
--  Rev.
--
---------------------------------------------------------------------------------------------
-- Naming Conventions:
--  Generics start with:                                    "C_*"
--  Ports
--      All words in the label of a port name start with a upper case, AnInputPort.
--      Active low ports end in                             "*_n"
--      Active high ports of a differential pair end in:    "*_p"
--      Ports being device pins end in _pin                 "*_pin"
--      Reset ports end in:                                 "*Rst"
--      Enable ports end in:                                "*Ena", "*En"
--      Clock ports end in:                                 "*Clk", "ClkDiv", "*Clk#"
--  Signals and constants
--      Signals and constant labels start with              "Int*"
--      Registered signals end in                           "_d#"
--      User defined types:                                 "*_TYPE"
--      State machine next state:                           "*_Ns"
--      State machine current state:                        "*_Cs"
--      Counter signals end in:                             "*Cnt", "*Cnt_n"
--   Processes:                                 "<Entity_><Function>_PROCESS"
--   Component instantiations:                  "<Entity>_I_<Component>_<Function>"
---------------------------------------------------------------------------------------------
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_UNSIGNED.all;
    use IEEE.std_logic_misc.all;
library UNISIM;
    use UNISIM.vcomponents.all;
library Prbs_Lib;
    use Prbs_Lib.all;
library xil_defaultlib;
    use xil_defaultlib.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
-- ClkInGen     : Clock input for the PRBS generator
-- ClkInChk     : Clock input for the PRBS checker
-- RstIn        : Reset input
-- InjErr       : Inject a PRBS error by toggling this bit.
-- PrbsGenEna   : Enable the PRBS generator
-- PrbsGen      : Output of the PRBS generator, number of bits = C_NumOfBits
-- PrbsVal      : Output every 10 clock cycles indicating that the PrbsGen value is valid.
-- PrbsChk      : Input for the PRBS checker, width = C_NumOfBits
-- PrbsChkEna   : Enable for the PRBS checker
-- ErrDet       : An error in the pattern is detected.
---------------------------------------------------------------------------------------------
entity Prbs_RxTx is
    generic (
        C_NumOfBits     : integer := 8;
        C_InvPattern    : boolean := FALSE;
        C_Poly_Length   : natural range 2 to 63 := 7;
        C_Poly_Tap      : natural range 1 to 62 := 6
    );
    port (
        ClkInGen    : in std_logic;
        ClkInChk    : in std_logic;
        RstInGen    : in std_logic;
        RstInChk    : in std_logic;
        InjErr      : in std_logic;
        PrbsGenEna  : in std_logic;
        PrbsGen     : out std_logic_vector(C_NumOfBits-1 downto 0);
        PrbsValid   : out std_logic;
        PrbsChk     : in std_logic_vector(C_NumOfBits-1 downto 0);
        PrbsChkEna  : in std_logic;
        PrbsErrDet  : out std_logic
    );
end Prbs_RxTx;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture Prbs_RxTx_arch of Prbs_RxTx is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic	:= '0';
constant High : std_logic	:= '1';
-- Signals
signal IntInjErrInp    : std_logic;
signal IntInjErr       : std_logic_vector(C_NumOfBits-1 downto 0);
signal IntPrbsGenOut   : std_logic_vector(C_NumOfBits-1 downto 0);
signal IntPrbsGen      : std_logic_vector(C_NumOfBits-1 downto 0);
signal IntPrbsChk      : std_logic_vector(C_NumOfBits-1 downto 0);
signal IntPrbsChkErr   : std_logic_vector(C_NumOfBits-1 downto 0);
signal IntPrbsGenValCnt    : integer;
signal IntTermCnt      : std_logic := '0';
signal IntRstCnt       : std_logic := '0';
-- Attributes
attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of Prbs_RxTx_arch : architecture is "YES";
    attribute DONT_TOUCH of IntInjErr : signal is "TRUE";
attribute LOC : string;
--        attribute LOC of  : label is ;
---------------------------------------------------------------------------------------------
begin
---------------------------------------------------------------------------------------------
-- Generate PRBS
---------------------------------------------------------------------------------------------
--IntInjErrInp <= not InjErr;
--
Prbs_RxTx_InjErr_PROCESS : process(ClkInGen)
begin
    if (ClkInGen'event and ClkInGen = '1') then
        if (RstInGen = '1') then
            IntInjErr <= (others => '0');
        else -- (RstIn = '0') then
            IntInjErr <= "0000000" & InjErr; -- IntInjErrInp;
        end if;
    end if;
end process;
--
    Prbs_RxTx_I_PrbsAny_Gen : entity xil_defaultlib.Prbs_Any
    generic map (      
        CHK_MODE      => FALSE,
        INV_PATTERN   => C_InvPattern,
        POLY_LENGHT   => C_Poly_Length,
        POLY_TAP      => C_Poly_Tap,
        NBITS         => C_NumOfBits -- 1
    )
    port map (
        RST           => RstInGen, --  in  
        CLK           => ClkInGen, --  in  
        DATA_IN       => IntInjErr, --  in  [NBITS - 1:0]
        EN            => PrbsGenEna, --  in  
        DATA_OUT      => IntPrbsGenOut --  out [NBITS - 1:0]
    );
--
Prbs_RxTx_PROCESS : process(ClkInGen)
begin
    if (ClkInGen'event and ClkInGen = '1') then
            -- Use this when NBITS is set to 1.
--          IntPrbsGen <= IntPrbsGenOut(0) & IntPrbsGen(C_NumOfBits-1 downto 1);
            PrbsGen <= IntPrbsGenOut;
        if (RstInGen = '1') then
            IntPrbsGenValCnt <= 0;
        elsif (PrbsGenEna = '1') then
            if (IntRstCnt = '1') then
                IntPrbsGenValCnt <= 0;
            else -- (IntRstCnt = '0')
                IntPrbsGenValCnt <= IntPrbsGenValCnt + 1;
            end if;
            --
            PrbsValid <= IntTermCnt;
        end if;
    end if;
end process;
--
-- Use this when NBITS is set to 1 and above shift register is used.
--PrbsGen <= IntPrbsGen;
IntTermCnt <= '1' when (IntPrbsGenValCnt = C_NumOfBits-2) else '0';
IntRstCnt <= '1'when (IntPrbsGenValCnt = C_NumOfBits-1) else '0';
---------------------------------------------------------------------------------------------
-- Check PrbsChk
---------------------------------------------------------------------------------------------
    Prbs_RxTx_I_PrbsAny_Chk : entity xil_defaultlib.Prbs_Any
    generic map (      
        CHK_MODE      => TRUE,
        INV_PATTERN   => C_InvPattern,
        POLY_LENGHT   => C_Poly_Length,
        POLY_TAP      => C_Poly_Tap,
        NBITS         => C_NumOfBits
    )
    port map (
        RST           => RstInChk, --  in  
        CLK           => ClkInChk, --  in  
        DATA_IN       => PrbsChk, --  in  [NBITS - 1:0]
        EN            => PrbsChkEna, --  in  
        DATA_OUT      => IntPrbsChkErr --  out [NBITS - 1:0]
    );
    --
    Prbs_RxTx_ErrDet_PROCESS : process(ClkInChk)
    begin
        if (ClkInChk'event and ClkInChk = '1') then
            PrbsErrDet <= OR_REDUCE(IntPrbsChkErr);
        end if;
    end process;
---------------------------------------------------------------------------------------------
end Prbs_RxTx_arch;
--