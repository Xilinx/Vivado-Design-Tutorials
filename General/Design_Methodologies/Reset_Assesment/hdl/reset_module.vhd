-- Copyright © Advanced Micro Devices, Inc., or its affiliates.
-- SPDX-License-Identifier: MIT

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

library UNISIM;
use UNISIM.vcomponents.all;

entity reset_module is
    generic
    (
        -- Core parameters
        NB_REG      : positive;     -- Number of registers
        ARCH_RST    : string        -- Type of reset
    );
    port
    (
        -- Reset domain
        reset       : in std_logic;
        
        -- Clock domain
        clk         : in std_logic;
        clk_g       : in std_logic
    );
end entity reset_module;

architecture rtl of reset_module is

    ---------------
    -- Constants --
    ---------------
    
    -- Number of SLRs
    constant    NB_SLR              : positive  := 3;
    
    -- Max number of clk counter
    constant    MAX_CLK_CNT         : positive  := 32;
    constant    CLK_CNT_WIDTH       : positive  := 5;

    constant    WAIT_FOR_CLK        : positive  := 5 + 1;       -- CE margin + safe cycle
    constant    RST_TREE_LATENCY    : positive  := 6 + 5 + 7;   -- Reset pipelining + Setup + Hold
    
    
    
    -----------
    -- Types --
    -----------
    
    type rst_fsm_state is
    (
        IDLE,
        CLK_DISABLED_1,
        RST_ASSERTED,
        CLK_ENABLED_1,
        CLK_DISABLED_2,
        RST_DEASSERTED
    );
    
    type    array_of_regs is array (natural range<>) of std_logic_vector((NB_REG/NB_SLR - 1) downto 0);

    -------------
    -- Signals --
    -------------

    -- Clock signals
    signal  free_clk          : std_logic := '0';
    signal  gated_clk            : std_logic := '0';

    -- Reset signals
    signal  reg_reset_1         : std_logic;
    signal  reg_reset_2         : std_logic;
    signal  reg_reset_3         : std_logic;
    signal  reg_reset_4         : std_logic;
    signal  reg_reset_5         : std_logic;
    signal  reg_reset_6         : std_logic;
    signal  reg_reset_7         : std_logic;
    signal  reg_reset_1_2       : std_logic;
    signal  reg_reset_1_3       : std_logic;
    signal  reg_reset_1_4       : std_logic;
    signal  reg_reset_1_5       : std_logic;
    signal  reg_reset_1_6       : std_logic;
    signal  reg_reset_1_7       : std_logic;
    signal  reg_reset_3_1       : std_logic;
    signal  reg_reset_3_2       : std_logic;
    signal  reg_reset_3_3       : std_logic;
    signal  reg_reset_3_4       : std_logic;
    signal  rst_leaf            : std_logic_vector((NB_SLR - 1) downto 0) := (others => '0');
    signal  regs                : array_of_regs((NB_SLR - 1) downto 0) := (others => (others =>'1'));

    -- Reset FSM
    signal  reg_current_state   : rst_fsm_state := IDLE;
    signal  reg_clk_cnt         : std_logic_vector((CLK_CNT_WIDTH - 1) downto 0) := (others => '0'); 
    signal  reg_clk_g_rst       : std_logic := '0';
    signal  reg_clk_en_1        : std_logic := '0';
    signal  reg_clk_en_2        : std_logic := '0';
    
    
    
    ---------------
    -- Attributs --
    ---------------

    attribute   DONT_TOUCH                      : string;
    attribute   DONT_TOUCH of regs              : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_1       : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_2       : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_3       : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_4       : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_5       : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_6       : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_1_2     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_1_3     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_1_4     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_1_5     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_1_6     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_3_1     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_3_2     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_reset_3_3     : signal is "TRUE";
    attribute   DONT_TOUCH of reg_clk_g_rst     : signal is "TRUE";

begin
    
    
    
    -----------
    -- Clock --
    -----------

    bufgce_clk : BUFGCE
    port map
    (
       I    => clk,
       CE   => '1',
       O    => free_clk
    );
    
    
    
    ----------------------------------
    -- Synchronous reset generation --
    ----------------------------------
    
    sync_rst : process(free_clk)
    begin
        if rising_edge(free_clk) then
            reg_reset_1   <=  reset;
        end if;
    end process sync_rst;
    
    
    
    -------------------
    -- Classic reset --
    -------------------

    generate_classic_rst : if (ARCH_RST = "CLASSIC_RST") generate
    begin
            
        gated_clk <= free_clk;
            
        pipe_rst : process(free_clk)
        begin
            if rising_edge(free_clk) then
                reg_reset_2 <= reg_reset_1;
                reg_reset_3 <= reg_reset_2;
                reg_reset_4 <= reg_reset_3;
                reg_reset_5 <= reg_reset_4;
                reg_reset_6 <= reg_reset_5;
                reg_reset_7 <= reg_reset_6;

                reg_reset_1_2 <= reg_reset_1;
                reg_reset_1_3 <= reg_reset_1_2;
                reg_reset_1_4 <= reg_reset_1_3;
                reg_reset_1_5 <= reg_reset_1_4;
                reg_reset_1_6 <= reg_reset_1_5;
                reg_reset_1_7 <= reg_reset_1_6;

                reg_reset_3_1 <= reg_reset_3;
                reg_reset_3_2 <= reg_reset_3_1;
                reg_reset_3_3 <= reg_reset_3_2;
                reg_reset_3_4 <= reg_reset_3_3;
            end if;
        end process pipe_rst;

        rst_leaf(0) <= reg_reset_1_7;
        rst_leaf(1) <= reg_reset_3_4;
        rst_leaf(2) <= reg_reset_7;

    end generate;
    
    
    
    ----------------------------
    -- BUFG distributed reset --
    ----------------------------
    
    generate_bufg_rst : if (ARCH_RST = "BUFG_RST") generate
    begin
            
        gated_clk <= free_clk;

        pipe_rst : process(free_clk)
        begin
            if rising_edge(free_clk) then
                reg_reset_2 <= reg_reset_1;
                reg_reset_3 <= reg_reset_2;
                reg_reset_4 <= reg_reset_3;
                reg_reset_5 <= reg_reset_4;
                reg_reset_6 <= reg_reset_5;
                reg_reset_7 <= reg_reset_6;

                reg_reset_1_2 <= reg_reset_1;
                reg_reset_1_3 <= reg_reset_1_2;
                reg_reset_1_4 <= reg_reset_1_3;
                reg_reset_1_5 <= reg_reset_1_4;
                reg_reset_1_6 <= reg_reset_1_5;
                reg_reset_1_7 <= reg_reset_1_6;

                reg_reset_3_1 <= reg_reset_3;
                reg_reset_3_2 <= reg_reset_3_1;
                reg_reset_3_3 <= reg_reset_3_2;
                reg_reset_3_4 <= reg_reset_3_3;
            end if;
        end process pipe_rst;

        bufg_rst_0 : BUFG
        port map
        (
            I => reg_reset_1_7,
            O => rst_leaf(0)
        );

        bufg_rst_1 : BUFG
        port map
        (
            I => reg_reset_3_4,
            O => rst_leaf(1)
        );

        bufg_rst_2 : BUFG
        port map
        (
            I => reg_reset_7,
            O => rst_leaf(2)
        );
    
    end generate generate_bufg_rst;
    
    
    
    ------------------------
    -- Reset clock-gating --
    ------------------------
    
    generate_clk_gating_rst : if (ARCH_RST = "CLOCK_GATING_RST") generate
    begin
    
        rst_fsm : process(free_clk)
        begin
            if rising_edge(free_clk) then
                case reg_current_state is
                    when IDLE           =>
                        if (reg_reset_1 = '1') then
                            reg_current_state   <= CLK_DISABLED_1;
                            -- Disable gated clock
                            reg_clk_en_1        <= '0';
                        end if;
                    when CLK_DISABLED_1  =>
                        -- A few wait cycles to ensure that the clock has stopped for the entire design
                        if (unsigned(reg_clk_cnt) = (WAIT_FOR_CLK - 1)) then
                            reg_current_state   <= RST_ASSERTED;
                            reg_clk_cnt         <= (others => '0');
                            -- Assert the reset
                            reg_clk_g_rst       <= '1';
                        else
                            reg_clk_cnt <= std_logic_vector(unsigned(reg_clk_cnt) + 1);
                        end if;
                    when RST_ASSERTED     =>
                        if (unsigned(reg_clk_cnt) = (RST_TREE_LATENCY - 1)) then
                            reg_current_state   <= CLK_ENABLED_1;
                            reg_clk_cnt         <= (others => '0');
                            -- Enable gated clock
                            reg_clk_en_1        <= '1';
                        else
                            reg_clk_cnt <= std_logic_vector(unsigned(reg_clk_cnt) + 1);
                        end if;
                    when CLK_ENABLED_1   =>
                        -- A few cycles under reset conditions.
                        if ( (unsigned(reg_clk_cnt) = (WAIT_FOR_CLK - 1)) and (reg_reset_1 = '0')) then
                            reg_current_state   <= CLK_DISABLED_2;
                            reg_clk_cnt         <= (others => '0');
                            -- Disable gated clock
                            reg_clk_en_1        <= '0';
                        else
                            reg_clk_cnt <= std_logic_vector(unsigned(reg_clk_cnt) + 1);
                        end if;
                    when CLK_DISABLED_2  =>
                        -- A few wait cycles to ensure that the clock has stopped for the entire design
                        if (unsigned(reg_clk_cnt) = (WAIT_FOR_CLK - 1)) then
                            reg_current_state   <= RST_DEASSERTED;
                            reg_clk_cnt         <= (others => '0');
                            -- De-assert the reset
                            reg_clk_g_rst       <= '0';
                        else
                            reg_clk_cnt <= std_logic_vector(unsigned(reg_clk_cnt) + 1);
                        end if;
                    when RST_DEASSERTED   =>
                        if (unsigned(reg_clk_cnt) = (RST_TREE_LATENCY - 1)) then
                            reg_current_state   <= IDLE;
                            reg_clk_cnt         <= (others => '0');
                            -- Enable gated clock
                            reg_clk_en_1        <= '1';
                        else
                            reg_clk_cnt <= std_logic_vector(unsigned(reg_clk_cnt) + 1);
                        end if;
                end case;
            end if;
        end process rst_fsm;

        pipe_rst : process(free_clk)
        begin
            if rising_edge(free_clk) then
                reg_reset_2 <= reg_clk_g_rst;
                reg_reset_3 <= reg_reset_2;
                reg_reset_4 <= reg_reset_3;
                reg_reset_5 <= reg_reset_4;
                reg_reset_6 <= reg_reset_5;
                reg_reset_7 <= reg_reset_6;

                reg_reset_1_2 <= reg_clk_g_rst;
                reg_reset_1_3 <= reg_reset_1_2;
                reg_reset_1_4 <= reg_reset_1_3;
                reg_reset_1_5 <= reg_reset_1_4;
                reg_reset_1_6 <= reg_reset_1_5;
                reg_reset_1_7 <= reg_reset_1_6;

                reg_reset_3_1 <= reg_reset_3;
                reg_reset_3_2 <= reg_reset_3_1;
                reg_reset_3_3 <= reg_reset_3_2;
                reg_reset_3_4 <= reg_reset_3_3;

                reg_clk_en_2 <= reg_clk_en_1;
            end if;
        end process pipe_rst;

        bufg_rst_0 : BUFG
        port map
        (
            I => reg_reset_1_7,
            O => rst_leaf(0)
        );

        bufg_rst_1 : BUFG
        port map
        (
            I => reg_reset_3_4,
            O => rst_leaf(1)
        );

        bufg_rst_2 : BUFG
        port map
        (
            I => reg_reset_7,
            O => rst_leaf(2)
        );

        bufgce_clk_g : BUFGCE
        port map
        (
           I    => clk_g,
           CE   => reg_clk_en_2,
           O    => gated_clk
        );
        
    end generate generate_clk_gating_rst;
    
    
    
    ------------------------
    -- Registers to reset --
    ------------------------

    regs_to_reset_loop : for i in 0 to (NB_SLR - 1) generate
    begin
    
        regs_to_reset : process(gated_clk)
        begin
            if rising_edge(gated_clk) then
                if (rst_leaf(i) = '1') then
                    regs(i) <= (others => '0');
                --else
                --    regs(i) <= (others => '1');
                end if;
            end if;
        end process regs_to_reset;
                
    end generate regs_to_reset_loop;


end architecture rtl;
