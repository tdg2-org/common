-- vhdl 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity long_comb_path is 
  port (
    rst   : in  std_logic;
    clk   : in  std_logic;
    d_i   : in  std_logic_vector(31 downto 0);
    --div_i : in  unsigned(4 downto 0);
    d_o   : out std_logic
  );
end long_comb_path;

architecture rtl of long_comb_path is 
-- components/attributes/constants/types/signals

  attribute keep        : string;
  attribute dont_touch  : string;

  constant dLen  : integer := (d_i'length -1);

  constant CNT_1S : unsigned(27 downto 0) := x"5F5E100";

  signal cnt, cnt_max : unsigned(27 downto 0);
  signal led          : std_logic;

  signal d            : std_logic_vector(dLen downto 0) := (others => '0');
  signal dlong        : std_logic_vector(dLen downto 0) := (others => '0');

  attribute keep of d,dlong : signal is "true";
  attribute dont_touch of d,dlong : signal is "true";

----------------------------------------------------------------------------------------------------
begin  -- architecture
-------------------------------------------------------------------------------------------------       

  inFFproc : process(clk) begin 
    if rising_edge(clk) then
      d <= d_i;
    end if;
  end process;

  dlong(0) <= d(0) xor d(1);
  dlong(1) <= dlong(0) and d(2);
  dlong(2) <= dlong(1) xor d(3);
  dlong(3) <= dlong(2) xor dlong(1);
  dlong(4) <= dlong(3) and not dlong(2);
  dlong(5) <= dlong(4) xor not dlong(3);
  
  gen_chain : for i in 6 to dLen generate begin
    dlong(i) <= dlong(i-1) xor not dlong(i-2);
  end generate;

  outFFproc : process(clk) begin
    if rising_edge(clk) then
      d_o <= dlong(dLen);
    end if;
  end process;


end architecture rtl;

--
--  long_comb_path_inst : entity work.long_comb_path
--    port map (
--      rst => rst,
--      clk => clk,
--      d_i => d_i,
--      d_o => d_o
--  );
--
--
--  long_comb_path long_comb_path_inst (
--    .rst (rst),
--    .clk (clk),
--    .d_i (d_i),
--    .d_o (d_o)
--  );
--

