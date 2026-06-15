-- Copyright © Advanced Micro Devices, Inc., or its affiliates.
-- SPDX-License-Identifier: MIT

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;

entity reset_module_tb is
end entity reset_module_tb;

architecture behavioural of reset_module_tb is
    
    ---------------
    -- Constants --
    ---------------
    
    -- Clk
    constant    CLK_PERIOD          : time  := 10 ns; -- 100 MHz

        -- Core parameters
    constant    NB_REG              : positive := 3;
    constant    ARCH_RST            : string   := "CLOCK_GATING_RST"; -- Type of reset
    
    -------------
    -- Signals --
    -------------
    
    -- Clock domains
    signal  clk             : std_logic := '1';
    signal  clk_g           : std_logic := '1';
    signal  reset           : std_logic := '0';
    
begin
    
    ---------------------
    -- Clock and Reset --
    ---------------------

    clk             <=  not(clk)        after   (CLK_PERIOD / 2);
    clk_g           <=  not(clk_g)      after   (CLK_PERIOD / 2);
    
    
    
    ------------------
    -- Main process --
    ------------------

    process
        begin

            -- Init
            reset  <= '0';
            wait for 100 us;
            
            -- Trigger Reset
            wait until rising_edge(clk);
            wait for 1 ns;
            reset  <= '1';
            wait until rising_edge(clk);
            wait for 1 ns;
            reset  <= '0';
            wait for 100 ns;
            
            wait;
            
    end process;

    
    
    
    ---------
    -- DUT --
    ---------

    sync_reset_clk_gating : entity work.reset_module
    generic map
    (
        -- Core parameters
        NB_REG      => NB_REG,
        ARCH_RST    => ARCH_RST
    )
    port map
    (
        -- Reset domain
        reset       => reset,
        
        -- Clock domain
        clk         => clk,
        clk_g       => clk_g
    );
    
end architecture behavioural;

