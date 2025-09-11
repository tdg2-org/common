-- vhdl 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test is 
  generic ( 
    maxCnt  : std_logic_vector := "0"
    );
  port (
    rst   : in  std_logic;
    clk   : in  std_logic;
    wren_i: in  std_logic;
    div_i : in  unsigned(4 downto 0);
    led_o : out std_logic
  );
end test;

architecture rtl of test is 

--  constant SIM : boolean := false
--  --pragma synthesis_off
--    or true
--  --pragma synthesis_on  

  --constant CNT_1S : unsigned(27 downto 0) := x"5F5E100";
  constant CNT_1S : unsigned(27 downto 0) := x"0000100";

  type smType is (IDLE, S1,S2,S3,S_END);
  signal sm : smType;

  signal cnt, cnt_max : unsigned(27 downto 0);
  signal led          : std_logic;

  signal probe0, probe1 : std_logic_vector(4 downto 0);
  
  signal sm_end, sm_end_re, sm_end_fe : std_logic := '0';
  signal sm_end_sr : std_logic_vector(1 downto 0);

---------------------------------------------------------------------------------------------------
begin  -- architecture
---------------------------------------------------------------------------------------------------       

  smProc : process(clk) begin 
    if rising_edge(clk) then 
      if (rst) then 
        sm <= IDLE;
      else 
        sm_end_sr <= sm_end_sr(0) & sm_end;
        case sm is 
          when IDLE => 
            sm_end <= '0';
            if (cnt = x"0000040") then 
              sm <= S1;
            end if;
          when S1 => 
            if (cnt = x"0000044") then 
              sm <= S2;
            end if;
          when S2 => 
            sm <= S3;
          when S3 => 
            if (cnt = x"0000078") then 
              sm <= S_END;
            end if;
          when S_END => 
            sm_end <= '1';
            if (cnt = cnt_max) then 
              sm <= IDLE;
            end if;
          when others => 
            sm <= IDLE;
        end case;
      end if;
    end if;
  end process;

  sm_end_re <= '1' when (sm_end_sr = "01") else '0';
  sm_end_fe <= '1' when (sm_end_sr = "10") else '0';

  cnt_max <=  CNT_1S when (div_i = "00000") else
              CNT_1S when (div_i > x"14") else 
              (CNT_1S / div_i);

  ledCntProc : process(clk) begin 
    if rising_edge(clk) then
      if (rst = '1') then 
        cnt <= (others => '0');
        led <= '0';
      else
        if ((cnt = cnt_max) OR (wren_i = '1')) then
          cnt <= (others => '0');
          led <= NOT led;
        else 
          cnt <= cnt + 1;
        end if;
      end if;
    end if;
  end process;

  led_o <= led;

---------------------------------------------------------------------------------------------------
-- debug
---------------------------------------------------------------------------------------------------       

--ila1: entity work.ila1
--  port map (
--    clk     => clk,
--    probe0  => probe0,
--    probe1  => probe1
--  );
--
--  probe0(2 downto 0) <= std_logic_vector(cnt(2 downto 0));
--  probe0(3) <= rst;
--  probe0(4) <= wren_i;
--  probe1 <= std_logic_vector(div_i);

end architecture rtl;

