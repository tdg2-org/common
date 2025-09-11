
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end entity test_tb;

architecture bhv of test_tb is 

---------------------------------------------------------------------------------------------------
-- constants/types/signals
---------------------------------------------------------------------------------------------------

  signal clk,wren,led   : std_logic := '0';
  signal rst : std_logic := '1';
  signal div : unsigned(4 downto 0) := "00000";


---------------------------------------------------------------------------------------------------
begin  -- architecture
---------------------------------------------------------------------------------------------------       
  clk <= not clk after 5 ns; -- 100mhz
  rst <= '0' after 100 ns;

--  gen_test : for i in 0 to 3 generate
    test_inst : entity work.test 
      generic map (
        maxCnt  => x"F"
        )
      port map (
        rst     => rst  ,
        clk     => clk  ,
        wren_i  => wren ,
        div_i   => div  ,
        led_o   => led  
      );
--  end generate;


end architecture bhv;