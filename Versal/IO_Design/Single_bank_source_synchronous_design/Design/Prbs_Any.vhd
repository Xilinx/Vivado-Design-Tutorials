--------------------------------------------------------------------------------
--    File Name:  Prbs_Any.vhd
--      Version:  1.0
--         Date:  6-jul-10
--------------------------------------------------------------------------------
--
--      Company:  Xilinx, Inc.
--  Contributor:  Daniele Riccardi, Paolo Novellini
-- 
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2010 Xilinx, Inc.
--                All rights reserved.
--
----------------------------------------------------------------------------
-- DESCRIPTION
----------------------------------------------------------------------------
--   This module generates or check a PRBS pattern. The following table shows how  
--   to set the GENERICS for compliance to ITU-T Recommendation O.150 Section 5.
--    
--   When the CHK_MODE is "false", it uses a  LFSR strucure to generate the
--   PRBS pattern.
--   When the CHK_MODE is "true", the incoming data are loaded into prbs registers
--   and compared with the locally generated PRBS 
-- 
----------------------------------------------------------------------------
-- GENERICS 
----------------------------------------------------------------------------
--   CHK_MODE     : true =>  check mode
--                  false => generate mode
--   INV_PATTERN  : true : invert prbs pattern
--                     in "generate mode" the generated prbs is inverted bit-wise at outputs
--                     in "check mode" the input data are inverted before processing
--   POLY_LENGHT  : length of the polynomial (= number of shift register stages)
--   POLY_TAP     : intermediate stage that is xor-ed with the last stage to generate to next prbs bit 
--   NBITS        : bus size of DATA_IN and DATA_OUT
--
----------------------------------------------------------------------------
-- NOTES
----------------------------------------------------------------------------
--
--
--   Set paramaters to the following values for a ITU-T compliant PRBS
--------------------------------------------------------------------------------
-- POLY_LENGHT POLY_TAP INV_PATTERN  || nbr of   bit seq.   max 0      feedback   
--                                   || stages    length  sequence      stages  
-------------------------------------------------------------------------------- 
--     7          6       false      ||    7         127      6 ni        6, 7   
--     9          5       false      ||    9         511      8 ni        5, 9   
--    11          9       false      ||   11        2047     10 ni        9,11   
--    15         14       true       ||   15       32767     15 i        14,15   
--    20          3       false      ||   20     1048575     19 ni        3,20   
--    23         18       true       ||   23     8388607     23 i        18,23   
--    29         27       true       ||   29   536870911     29 i        27,29   
--    31         28       true       ||   31  2147483647     31 i        28,31   
--
-- i=inverted, ni= non-inverted
------------------------------------------------------------------------------
--
-- In the generated parallel PRBS, LSB is the first generated bit, for example
--         if the PRBS serial stream is : 000001111011... then
--         the generated PRBS with a parallelism of 3 bit becomes:
--            data_out(2) = 0  1  1  1 ... 
--            data_out(1) = 0  0  1  1 ...  
--            data_out(0) = 0  0  1  0 ... 
-- In the received parallel PRBS, LSB is oldest bit received
--
-- RESET pin is not needed for power-on reset : all registers are properly inizialized 
-- in the source code.
-- 
--------------------------------------------------------------------------------
-- PINS DESCRIPTION 
--------------------------------------------------------------------------------
--
--      RST          : in : syncronous reset active high
--      CLK          : in : system clock
--      DATA_IN      : in : inject error (in generate mode)
--                          data to be checked (in check mode)
--      EN           : in : enable/pause pattern generation/check
--      DATA_OUT     : out: generated prbs pattern (in generate mode)
--                          error found (in check mode)
--
  
---------------------------------------------------------------------------------------------------
-- History:
--      Version    : 1.0
--      Date       : 6-jul-10
--      Author     : Daniele Riccardi
--      Description: First release

---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Prbs_Any is
   generic (      
      CHK_MODE: boolean := false; 
      INV_PATTERN : boolean := false;
      POLY_LENGHT : natural range 2 to 63 := 7 ;
      POLY_TAP : natural range 1 to 62 := 6 ;
      NBITS : natural range 1 to 512 := 8
   );
   port (
      RST             : in  std_logic;                            -- sync reset active high
      CLK             : in  std_logic;                            -- system clock
      DATA_IN         : in  std_logic_vector(NBITS - 1 downto 0); -- inject error/data to be checked
      EN              : in  std_logic;                            -- enable/pause pattern generation
      DATA_OUT        : out std_logic_vector(NBITS - 1 downto 0):= (others => '0')  -- generated prbs pattern/errors found
   );
end Prbs_Any;

architecture Prbs_Any of Prbs_Any is

   type prbs_type is array (NBITS downto 0) of std_logic_vector(1 to POLY_LENGHT);
   signal prbs : prbs_type := (others => (others => '1'));
  
   signal data_in_i : std_logic_vector(NBITS-1 downto 0);    
   signal prbs_xor_a : std_logic_vector(NBITS-1 downto 0);                                                  
   signal prbs_xor_b : std_logic_vector(NBITS-1 downto 0);                                                 
   signal prbs_msb : std_logic_vector(NBITS downto 1); 
      
begin 

   data_in_i <= DATA_IN when INV_PATTERN = false else (not DATA_IN);
           
   g1: for I in 0 to NBITS-1 generate            
      prbs_xor_a(I) <= prbs(I)(POLY_TAP) xor prbs(I)(POLY_LENGHT);
      prbs_xor_b(I) <= prbs_xor_a(I) xor data_in_i(I);      
      prbs_msb(I+1) <= prbs_xor_a(I) when CHK_MODE = false else data_in_i(I);        
      prbs(I+1) <= prbs_msb(I+1) & prbs(I)(1 to POLY_LENGHT-1);      
   end generate;
      
   PRBS_GEN_01 : process (CLK)
   begin
      if rising_edge(CLK) then
         if RST = '1' then
            prbs(0) <= (others => '1');
            DATA_OUT <= (others => '1');
         elsif EN = '1' then
            DATA_OUT <= prbs_xor_b;
            prbs(0) <= prbs(NBITS);                                                                  
         end if;
      end if;
   end process;
  
            
end Prbs_Any;